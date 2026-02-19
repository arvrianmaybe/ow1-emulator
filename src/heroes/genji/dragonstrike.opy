#!mainFile "../../dev_main.opy"


rule "[genji/dragonstrike.opy]: Increase Dragonstrike damage after ultimate":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate()
    
    if eventPlayer.swift_strike_charges == OW1_GENJI_MAX_SWIFT_STRIKE: return
    else: eventPlayer.swift_strike_charges += 1

    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(140) # Compensation for not being able to increase firerate
    wait(OW1_GENJI_DRAGONSTRIKE_DAMAGE_INCREASE_DURATION)
    eventPlayer.setDamageDealt(100)
