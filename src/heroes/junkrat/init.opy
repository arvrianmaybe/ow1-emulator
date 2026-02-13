#!mainFile "../../dev_main.opy"

#!include "trap.opy"


def initJunkrat():
    @Name "[junkrat/init.opy]: initJunkrat()"

    setCustomHp(OW1_JUNKRAT_HEALTH, 0, 0)
    setUltCost(OW1_JUNKRAT_ULT_COST)
    # removeSelfHealing()

    eventPlayer.setProjectileSpeed(percent(OW1_JUNKRAT_FRAG_PROJECTILE_SPEED/OW2_JUNKRAT_FRAG_PROJECTILE_SPEED))
    setBaseDamage(eventPlayer, OW1_JUNKRAT_FRAG_DAMAGE/OW2_JUNKRAT_FRAG_DAMAGE)


rule "[junkrat/init.opy]: Correct Mine, Tire damage":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility in [Button.ABILITY_1, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
