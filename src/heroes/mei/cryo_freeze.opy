#!mainFile "../../dev_main.opy"


rule "[mei/cryo_freeze.opy]: OW1 Cryo-Freeze healing + Size":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setHealingReceived(percent(OW1_MEI_CRYO_HEALING/OW2_MEI_CRYO_HEALING))
    eventPlayer.startScalingSize(1.5, false)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setHealingReceived(100)
    eventPlayer.stopScalingSize()