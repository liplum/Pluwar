from enum import Enum, auto
from typing import Protocol, runtime_checkable, Iterable
from datetime import datetime
import logger
from encode import PayloadConvertible
from user import AuthUser


class ActionType(Enum):
    Damage = auto()
    Restore = auto()
    Effect = auto()


@runtime_checkable
class Action(Protocol):
    type: ActionType
    amount: float

    def toPayload(self) -> dict:
        pass


class DamageAction(Action):
    type = ActionType.Damage

    def __init__(self, amount: float):
        self.amount = amount

    def toPayload(self) -> dict:
        return {
            "type": "damage",
            "amount": self.amount
        }


class BattleContext:
    pass


# noinspection PyTypeChecker
class SkillContext:
    def __init__(self):
        self.actions = []
        self.battle: BattleContext = None
        self.target: ElfEntity = None
        self.performer: ElfEntity = None

    def addAction(self, action: Action):
        self.actions.append(action)


@runtime_checkable
class SkillEffect(Protocol):
    name: str

    def perform(self, ctx: SkillContext):
        pass


class Skill:
    def perform(self, ctx: SkillContext):
        pass


EmptySkill = Skill()


class Elf:
    def __init__(self):
        self.name = "Default Elf"
        self.description = "No description."


EmptyElf = Elf()


class SkillEntity:
    def __init__(self):
        self.type: Skill = EmptySkill
        self.availableCount = 0


class ElfEntity:
    def __init__(self):
        self.type = EmptyElf
        self.hp = 0
        self.physicalDamage = 0
        self.magicDamage = 0
        self.skillSlots = []


class RoomStatus(Enum):
    waiting = auto()
    battle = auto()
    end = auto()


class PlayerEntry(PayloadConvertible):
    def __init__(self, player: AuthUser, isReady=False):
        self.user = player
        self.isReady = isReady

    @property
    def account(self) -> str:
        return self.user.account

    def toPayload(self) -> dict:
        return {
            "account": self.user.account,
            "isReady": self.isReady
        }


class RoomChatEntry(PayloadConvertible):
    def __init__(self, sender: AuthUser, content: str, timestamp: datetime):
        self.sender = sender
        self.content = content
        self.timestamp = timestamp

    def toPayload(self) -> dict:
        return {
            "sender": self.sender.account,
            "content": self.content,
            "ts": self.timestamp
        }


class Room(PayloadConvertible):
    """
    Before battle starts, room state is [Waiting] until both players are ready to start.
    """

    def __init__(self, manager: "RoomManager", roomId: str):
        self.manager = manager
        self.status = RoomStatus.waiting
        self.roomSize = 2
        self.roomId = roomId
        self.players: list[PlayerEntry] = []
        self.chats: list[RoomChatEntry] = []

    def isFull(self) -> bool:
        return len(self.players) >= self.roomSize

    def isInRoom(self, user: AuthUser) -> bool:
        for entry in self.players:
            if entry.account == user.account:
                return True
        return False

    def findPlayer(self, account: str) -> PlayerEntry | None:
        for entry in self.players:
            if entry.account == account:
                return entry
        return None

    def leaveRoom(self, user: AuthUser) -> bool:
        index = -1
        account = user.account
        for i, entry in enumerate(self.players):
            if entry.account == account:
                index = i
        if 0 <= index < len(self.players):
            self.players.pop(index)
            if account in self.manager.account2Room:
                self.manager.account2Room.pop(account)
            if len(self.players) == 0:
                if self.roomId in self.manager.roomID2Room:
                    self.manager.roomID2Room.pop(self.roomId)
            logger.g(f"{account} left room[{self.roomId}].")
            return True
        else:
            return False

    def joinWith(self, user: AuthUser) -> bool:
        if not self.isInRoom(user):
            entry = PlayerEntry(user)
            self.players.append(entry)
            self.manager.account2Room[user.account] = self
            logger.g(f"{user.account} joined room[{self.roomId}].")
            return True
        else:
            return False

    def toPayload(self) -> dict:
        res = {
            "status": self.status,
            "roomId": self.roomId,
            "players": self.players
        }
        return res

    def resolveReceivers(self) -> Iterable[AuthUser]:
        for player in self.players:
            yield player.user
class RoomManager:
    def __init__(self):
        self.roomID2Room: dict[str, Room] = {}
        self.account2Room: dict[str, Room] = {}
        self.curRoomIdPtr = 10000

    def tryGetRoomById(self, roomId: str) -> Room | None:
        if roomId in self.roomID2Room:
            return self.roomID2Room[roomId]
        else:
            return None

    def tryGetRoomByAccount(self, account: str) -> Room | None:
        if account in self.account2Room:
            return self.account2Room[account]
        else:
            return None

    def newRoom(self) -> Room:
        self.curRoomIdPtr += 1
        roomId = str(self.curRoomIdPtr)
        room = Room(self, roomId)
        self.roomID2Room[roomId] = room
        logger.g(f"room[{roomId}] is created.")
        return room

    def availableRooms(self) -> Iterable[Room]:
        for room in self.roomID2Room.values():
            if not room.isFull():
                yield room
