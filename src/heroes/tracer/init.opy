#!mainFile "../../dev_main.opy"

#!include "pulse_pistol.opy"


def initTracer():
    @Name "[tracer/init.opy]: initTracer()"

    setCustomHp(OW1_TRACER_HEALTH, 0, 0)
    setUltCost(OW1_TRACER_ULT_COST)
    # removeSelfHealing()

    startDamageModification(eventPlayer, eventPlayer, 0)
    eventPlayer.stop_self_damage = getLastDamageModification()


rule "[tracer/init.opy]: Deal OW1 tracer Pulse Bomb damage":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility == Button.ULTIMATE

    heal(victim, attacker, eventDamage*(OW1_TRACER_PULSE_BOMB_DAMAGE/OW2_TRACER_PULSE_BOMB_DAMAGE)-eventDamage)


rule "[tracer/init.opy]: Clean up Tracer":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.TRACER

    waitUntil(eventPlayer.getCurrentHero() != Hero.TRACER, Math.INFINITY)
    stopDamageModification(eventPlayer.stop_self_damage)