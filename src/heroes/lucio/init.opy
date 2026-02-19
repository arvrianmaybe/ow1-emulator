#!mainFile "../../dev_main.opy"

# !include "soundwave.opy"
#!include "aura.opy"


def initLucio():
    @Name "[lucio/init.opy]: initLucio()"
    
    setCustomHp(OW1_LUCIO_HEALTH, 0, 0)
    setUltCost(OW1_LUCIO_ULT_COST)
    # removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE)

    eventPlayer.setKnockbackDealt(percent(OW1_LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))


rule "[lucio/init.opy]: OW1 Lucio gun damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)


# rule "[lucio/init.opy]: Compensate Lucio global damage reduction":
#     @Event playerDealtDamage
#     @Hero lucio
#     @Condition eventAbility in []

#     damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


rule "[lucio/init.opy]: Reduce Soundbarrier overhealth":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    wait()
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
        getPlayersInRadius(eventPlayer.getPosition(), 
            OW1_LUCIO_SOUND_BARRIER_AREA_OF_EFFECT, 
            getOppositeTeam(eventPlayer.getTeam()), 
            LosCheck.SURFACES).applyImpulse(Vector.UP, 5.25, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

        getPlayersInRadius(eventPlayer.getPosition(), 
            OW1_LUCIO_SOUND_BARRIER_AREA_OF_EFFECT, 
            getOppositeTeam(eventPlayer.getTeam()), 
            LosCheck.SURFACES).applyImpulse(getForwardDirection(eventPlayer), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)