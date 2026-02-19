#!mainFile "../../dev_main.opy"

playervar viper_pvar
#!define ashe_is_reloading viper_pvar[0]

rule "[ashe/viper.opy]: Detect if Ashe is Reloading":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.isReloading()

    eventPlayer.ashe_is_reloading = true


rule "[ashe/viper.opy]: Set Ashe Reload time":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.ashe_is_reloading

    # Disable all Abilities to repliate Reloading
    eventPlayer.setReloadEnabled(false)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)

    smallMessage(eventPlayer, "Reloading...") # Give out a Small Message to let user know that their reloading
    wait(OW1_ASHE_RELOAD_TIME, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "Finished Reloaded") # Give out a Small Message to let user know that they finished reloading

    # Reload ammo, Enable all Abilities & Melee
    eventPlayer.setAmmo(0, OW1_ASHE_CLIP_SIZE)
    eventPlayer.setReloadEnabled(true)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)

    eventPlayer.ashe_is_reloading = false


rule "[ashe/viper.opy]: Abort Ashe reloading if CC or using Abilities":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.ashe_is_reloading
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 \
        or eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0 \
        or eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.getUltCharge() == 100 \
        or eventPlayer.isHoldingButton(Button.MELEE) \
        or isCCd(eventPlayer)

    eventPlayer.ashe_is_reloading = false

    smallMessage(eventPlayer, "Cancelled Reloading") # Give out a Small Message to let user know that they cancelled reloading

    # Enable all Abilities & Melee but not Reload ammo
    eventPlayer.setReloadEnabled(true)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)

    if eventPlayer.isHoldingButton(Button.ABILITY_1): # Shoot out Coach Gun
        eventPlayer.forceButtonPress(Button.ABILITY_1)

    elif eventPlayer.isHoldingButton(Button.ABILITY_2): # Shoot out Dynamite
        eventPlayer.forceButtonPress(Button.ABILITY_2)

    elif eventPlayer.isHoldingButton(Button.ULTIMATE): # Call out B.O.B
        eventPlayer.forceButtonPress(Button.ULTIMATE)

    elif eventPlayer.isHoldingButton(Button.MELEE): # Force out Melee
        eventPlayer.forceButtonPress(Button.MELEE)