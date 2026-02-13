#!mainFile "../../dev_main.opy"

# rule "[roadhog/breather.opy]: Remove healing buff after breather":
#     @Event eachPlayer
#     @Hero roadhog
#     @Condition eventPlayer.isUsingAbility2()

#     wait(OW2_ROADHOG_BREATHER_DURATION, Wait.ABORT_WHEN_FALSE)
#     eventPlayer.setHealingReceived(percent(1/(1+OW2_ROADHOG_BREATHER_HEAL_BUFF)))
#     wait(OW2_ROADHOG_BREATHER_HEAL_BUFF_DURATION)
#     eventPlayer.setHealingReceived(100)

rule "[roadhog/breather.opy]: OW1 Take a Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isMeleeing()

    eventPlayer.setDamageReceived(percent((1-OW1_ROADHOG_BREATHER_DAMAGE_REDUCTION)/(1-OW2_ROADHOG_BREATHER_DAMAGE_REDUCTION)))
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(OW1_ROADHOG_BREATHER_CAST_TIME*2+OW1_ROADHOG_BREATHER_DURATION+TICK_DURATION)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ROADHOG_BREATHER_COOLDOWN)