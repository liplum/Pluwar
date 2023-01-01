from core.entity import *


class Dash(SkillEffect):
    """
    Deal physical damage based on 100% physical damage
    """
    name = "Dash"

    def perform(self, ctx: SkillContext):
        dmg = ctx.performer.physicalDamage
        ctx.target.hp -= dmg
        action = DamageAction(amount=dmg)
        ctx.addAction(action)
