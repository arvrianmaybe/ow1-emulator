#!mainFile "../../dev_main.opy"


rule "[torbjorn/overload.opy]: Correct overload hp":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.addHealthPool(Health.NORMAL, 33, false, false) # Magic numbers for the time being
    waitUntil(not eventPlayer.isUsingAbility2(), OW1_TORBJORN_OVERLOAD_DURATION)
    removeHealthPool(getLastCreatedHealthPool())