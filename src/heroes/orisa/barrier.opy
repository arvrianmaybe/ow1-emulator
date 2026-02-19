#!mainFile "../../dev_main.opy"

rule "[orisa/barrier.opy]: OW1 Orisa barrier health":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingAbility2()
    
    eventPlayer.setMaxHealth(percent(OW1_ORISA_PROJECTILE_BARRIER_HEALTH/OW2_ORISA_PROJECTILE_BARRIER_HEALTH))
    wait(1, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))