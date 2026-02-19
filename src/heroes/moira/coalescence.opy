#!mainFile "../../dev_main.opy"

playervar victim_coalescence_lift

rule "[moira/coalescence.opy]: Prevent fading during coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setMoveSpeed(percent(OW1_MOIRA_COALESCENCE_SPEED_BUFF/OW2_MOIRA_COALESCENCE_SPEED_BUFF))
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setAbility1Enabled(true)


rule "[moira/coalescence.opy]: OW1 coalescence damage":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.ULTIMATE

    heal(victim, null, eventDamage - (OW1_MOIRA_COALESCENCE_DAMAGE/OW2_MOIRA_COALESCENCE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))


rule "[moira/coalescence.opy]: OW1 Coalescence lift":
    @Event playerDealtDamage
    @Hero moira
    @Condition not victim.victim_coalescence_lift
    @Condition eventAbility == Button.ULTIMATE

    wait(OW1_MOIRA_COALESCENCE_LIFT_COOLDOWN, Wait.ABORT_WHEN_FALSE)
    victim.victim_coalescence_lift = true
    waitUntil(not eventPlayer.isUsingUltimate())
    victim.victim_coalescence_lift = false

rule "[moira/coalescence.opy]: Lift up Victims":
    @Event eachPlayer
    @Condition eventPlayer.victim_coalescence_lift

    eventPlayer.startAcceleration(vect(0, 5, 0), 20, 6, Relativity.TO_WORLD)
    wait(OW1_MOIRA_COALESCENCE_LIFT_DURATION)
    eventPlayer.stopAcceleration()
