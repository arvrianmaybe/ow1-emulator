#!mainFile "../../dev_main.opy"

#!include "bob.opy"
#!include "viper.opy"

playervar stop_self_damage

def initAshe():
    @Name "[ashe/init.opy]: initAshe()"
    
    setCustomHp(OW1_ASHE_HEALTH, 0, 0)
    setUltCost(OW1_ASHE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_ASHE_BOB_DAMAGE/OW2_ASHE_BOB_DAMAGE)

    # removeSelfHealing()

    startDamageModification(eventPlayer, eventPlayer, 0)
    eventPlayer.stop_self_damage = getLastDamageModification()


rule "[ashe/init.opy]: Clean up Ashe":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ASHE

    waitUntil(eventPlayer.getCurrentHero() != Hero.ASHE, Math.INFINITY)
    stopDamageModification(eventPlayer.stop_self_damage)
    eventPlayer.ashe_is_reloading = false


rule "[ashe/init.opy]: Compensate Ashe global damage reduction":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

# rule "[ashe/init.opy]: No self Burning effect on Dynamite":
#     @Event playerDealtDamage
#     @Hero ashe
#     @Condition eventAbility == Button.ABILITY_2
#     @Condition victim == attacker
# 
#     eventPlayer.clearStatusEffect(Status.BURNING)