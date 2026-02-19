#!mainFile "../../dev_main.opy"

# !include "transc.opy"

def initZenyatta():
    @Name "[zenyatta/init.opy]: initZenyatta()"
    
    setCustomHp(OW1_ZENYATTA_HEALTH, 0, OW1_ZENYATTA_SHIELDS)
    setUltCost(OW1_ZENYATTA_ULT_COST)
    # removeSelfHealing()
    
    eventPlayer.setKnockbackDealt(percent(OW1_ZENYATTA_KNOCKBACK/OW2_ZENYATTA_KNOCKBACK))
    setBaseDamage(eventPlayer, OW1_ZENYATTA_ORB_DAMAGE/OW2_ZENYATTA_ORB_DAMAGE)

    # eventPlayer.setJumpVerticalSpeed(200)
    
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)


rule "[zenyatta/init.opy]: OW1 Zenyatta melee damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility == Button.MELEE

    heal(victim, null, eventDamage - (OW1_MELEE_DAMAGE/OW2_ZENYATTA_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))


rule "[zenyatta/init.opy]: OW1 Zenyatta Jump higher":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isJumping()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)