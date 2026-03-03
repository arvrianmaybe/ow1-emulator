#!mainFile "../../dev_main.opy"


rule "[bastion/repair.opy]: Toggleable self-repair & secondary fire keybind":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    eventPlayer.startForcingButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or not eventPlayer.isHoldingButton(Button.ABILITY_2), Math.INFINITY)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)