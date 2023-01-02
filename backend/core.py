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
