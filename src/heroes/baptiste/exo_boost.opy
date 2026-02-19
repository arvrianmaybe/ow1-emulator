#!mainFile "../../dev_main.opy"

playervar exo_boost_jump_height

rule "[baptiste/lamp.opy]: Increase Exo Boost height":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isCrouching()

    stopChasingVariable(eventPlayer.exo_boost_jump_height)
    eventPlayer.exo_boost_jump_height = 0
    wait(OW2_BAPTISTE_EXO_BOOST_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.exo_boost_jump_height = OW2_BAPTISTE_EXO_BOOST_DURATION
    chase(eventPlayer.exo_boost_jump_height, OW1_EXO_BOOST_MAX_DURATION, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.isJumping(), Math.INFINITY)
    eventPlayer.applyImpulse(Vector.UP, eventPlayer.exo_boost_jump_height*OW1_EXO_BOOST_JUMP_HEIGHT_INCREASE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "[baptiste/lamp.opy]: Cancel Exo Boost height":
    @Event eachPlayer
    @Hero baptiste
    @Condition not eventPlayer.isCrouching() or isCCd(eventPlayer) or eventPlayer.isJumping()

    stopChasingVariable(eventPlayer.exo_boost_jump_height)
    wait(OW2_BAPTISTE_EXO_BOOST_GRACE, Wait.ABORT_WHEN_FALSE)
    eventPlayer.exo_boost_jump_height = 0