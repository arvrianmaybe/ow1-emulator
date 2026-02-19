#!mainFile "../../dev_main.opy"


rule "[mccree/roll.opy]: Cant Roll while in Air":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isInAir()

    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isInAir(), Math.INFINITY)
    eventPlayer.allowButton(Button.ABILITY_1)


rule "[mccree/roll.opy]: Remove damage reduction during roll":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setDamageReceived(percent(100/(100-OW2_MCCREE_COMBAT_ROLL_DAMAGE_REDUCTION)))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setDamageReceived(100)
