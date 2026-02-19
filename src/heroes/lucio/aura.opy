#!mainFile "../../dev_main.opy"


# rule "[lucio/aura.opy]: Allow self healing during heal aura":
#     @Event eachPlayer
#     @Hero lucio
#    @Condition not eventPlayer.isUsingAbility1()
# 
#    pushSelfHealing(Button.ABILITY_1)
#     waitUntil(eventPlayer.isUsingAbility1(), Math.INFINITY)
#     popSelfHealing(Button.ABILITY_1)


rule "[lucio/aura.opy]: Damage increase in walls":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isOnWall()

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SONIC_AMPLIFIER_DAMAGE_WALL/OW1_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)