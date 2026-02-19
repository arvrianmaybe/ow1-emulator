#!mainFile "../../dev_main.opy"

playervar wraith_ammo


rule "[reaper/wraith.opy]: Get Wraith ammo":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.wraith_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingAbility1()
    
    wait(TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wraith_ammo = eventPlayer.getAmmo(0)

rule "[reaper/wraith.opy]: Set Wraith speed & ammo":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setMoveSpeed(percent(OW1_REAPER_WRAITH_MOVEMENT_INCREASE/OW2_REAPER_WRAITH_MOVEMENT_INCREASE))
    eventPlayer.setAmmo(0, eventPlayer.wraith_ammo)
    waitUntil((not eventPlayer.isUsingAbility1()), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)