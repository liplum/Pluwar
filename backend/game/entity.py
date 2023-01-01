class BattleContext:
    pass


class SkillContext:
    def __init__(self):
        self.battle: BattleContext
        self.target: ElfEntity


class Skill:
    def __init__(self):
        pass

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
        self.skillSlots = []
