#!mainFile "../../dev_main.opy"

#!include "pulse_rifle.opy"
# !include "biotic_field.opy"

def initSoldier():
    @Name "[soldier/init.opy]: initSoldier()"

    setCustomHp(OW1_SOLDIER_HEALTH, 0, 0)
    setUltCost(OW1_SOLDIER_ULT_COST)
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))
    # removeSelfHealing()

    startDamageModification(eventPlayer, eventPlayer, 0)
    eventPlayer.stop_self_damage = getLastDamageModification()


rule "[soldier/init.opy]: Clean up Soldier":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.SOLDIER

    waitUntil(eventPlayer.getCurrentHero() != Hero.SOLDIER, Math.INFINITY)
    stopDamageModification(eventPlayer.stop_self_damage)