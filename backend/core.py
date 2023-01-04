import uuid
from enum import Enum, auto
from typing import Protocol, runtime_checkable

from foundation import PayloadConvertible


class ActionType(Enum):
    Damage = auto()
    Restore = auto()
    Effect = auto()


@runtime_checkable
class Action(Protocol, PayloadConvertible):
    type: ActionType
    amount: float


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


class Room(PayloadConvertible):
    """
    Before battle starts, room state is [Waiting] until both players are ready to start.
    """

    def __init__(self, manager: "RoomManager", roomId: str):
        self.manager = manager
        self.roomStatus = RoomStatus.waiting
        self.roomId = roomId
        self.playerA: Player | None = None
        self.playerB: Player | None = None
        self.isPlayerAReady = False
        self.isPlayerBReady = False

    def isFull(self) -> bool:
        return self.playerA is not None and self.playerB is not None

    def isInRoom(self, account: str) -> bool:
        if self.playerA is not None and self.playerA.account == account:
            return True
        if self.playerB is not None and self.playerB.account == account:
            return True
        return False

    def joinWith(self, account: str) -> bool:
        if self.playerA is None:
            self.playerA = Player(account)
            self.manager.account2Room[account] = self
            return True
        elif self.playerB is None:
            self.playerB = Player(account)
            self.manager.account2Room[account] = self
            return True
        return False

    def toPayload(self) -> dict:
        return {
            "roomStatus": self.roomStatus.name,
            "roomId": self.roomId,
            "playerAAccount": self.playerA.account,
            "playerBAccount": self.playerB.account,
            "isPlayerAReady": self.isPlayerAReady,
            "isPlayerBReady": self.isPlayerBReady
        }


class RoomManager:
    def __init__(self):
        self.roomID2Room: dict[str, Room] = {}
        self.account2Room: dict[str, Room] = {}

    def tryGetRoom(self, roomId: str) -> Room | None:
        if roomId in self.roomID2Room:
            return self.roomID2Room[roomId]
        else:
            return None

    def newRoom(self) -> Room:
        roomId = uuid.uuid4().hex
        room = Room(self, roomId)
        self.roomID2Room[roomId] = room
        return room
