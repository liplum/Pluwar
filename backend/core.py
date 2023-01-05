import uuid
from enum import Enum, auto
from typing import Protocol, runtime_checkable

from encode import PayloadConvertible


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


class Player:
    def __init__(self, account: str):
        self.account = account


class RoomStatus(Enum):
    waiting = auto()
    battle = auto()
    end = auto()


class PlayerEntry(PayloadConvertible):
    def __init__(self, player: Player, isReady=False):
        self.player = player
        self.isReady = isReady

    @property
    def account(self) -> str:
        return self.player.account

    def toPayload(self) -> dict:
        return {
            "account": self.player.account,
            "isReady": self.isReady
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

    def isFull(self) -> bool:
        return len(self.players) >= self.roomSize

    def isInRoom(self, account: str) -> bool:
        for entry in self.players:
            if entry.account == account:
                return True
        return False

    def findPlayer(self, account: str) -> PlayerEntry | None:
        for entry in self.players:
            if entry.account == account:
                return entry
        return None

    def joinWith(self, account: str) -> bool:
        if not self.isInRoom(account):
            player = Player(account)
            entry = PlayerEntry(player)
            self.players.append(entry)
            self.manager.account2Room[account] = self
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


class RoomManager:
    def __init__(self):
        self.roomID2Room: dict[str, Room] = {}
        self.account2Room: dict[str, Room] = {}

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
        roomId = uuid.uuid4().hex
        room = Room(self, roomId)
        self.roomID2Room[roomId] = room
        return room
