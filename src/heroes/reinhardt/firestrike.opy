#!mainFile "../../dev_main.opy"


rule "[reinhardt/firestrike.opy]: Force single firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.ABILITY_2) # Fail-safe when button mashing firestrike to cast 2nd one
    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0) # Every time rein uses firestrike, reset the resource to 0
    wait(OW1_REINHARDT_FIRESTRIKE_COOLDOWN_TIME)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2) 
    eventPlayer.allowButton(Button.ABILITY_2)


rule "[reinhardt/leap.opy]: Decrease Firstrike victim healing":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == [Button.ABILITY_2]

    victim.setHealingReceived(50)
    wait(OW1_REINHARDT_FIRESTRIKE_HEALING_REDUCTION_DURATION)
    victim.setHealingReceived(100)