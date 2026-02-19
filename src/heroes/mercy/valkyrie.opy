#!mainFile "../../dev_main.opy"


playervar valkyrie_pvar
#!defineMember valkyrie_ult_charge valkyrie_pvar[0]
#!defineMember is_exiting_valkryie valkyrie_pvar[1]
#!defineMember mercy_health reset_pvar[15]
#!defineMember guardian_angel_cooldown valkyrie_pvar[3]
#!defineMember caduceus_ammo valkyrie_pvar[4]

subroutine cancelValkyrie


rule "[mercy/valkyrie.opy]: Use Valkyrie if using Ability 2":
    @Event eachPlayer
    @Hero mercy
    @Condition not isCCd(eventPlayer)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0

    eventPlayer.valkyrie_ult_charge = eventPlayer.getUltCharge()
    eventPlayer.setUltCharge(100)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait(OW1_MERCY_VALKYRIE_DURATION)
    eventPlayer.setUltCharge(eventPlayer.valkyrie_ult_charge)
    cancelValkyrie()

def cancelValkyrie():
    @Name "[mercy/valkyrie.opy]: cancelValkyrie()"
    
    # Save Mercy state
    eventPlayer.mercy_health = eventPlayer.getHealth()
    eventPlayer.guardian_angel_cooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    eventPlayer.caduceus_ammo = eventPlayer.getAmmo(0)

    eventPlayer.is_exiting_valkryie = true
    eventPlayer.startForcingHero(Hero.ZARYA)

# Switch back to mercy after entering zarya
rule "[mercy/valkyrie.opy]: Go back to mercy":
    @Event eachPlayer
    @Condition eventPlayer.is_exiting_valkryie

    eventPlayer.startForcingHero(Hero.MERCY)
    eventPlayer.stopForcingCurrentHero()

    # Restore Mercy state
    setCustomHp(eventPlayer._hp_health, eventPlayer._hp_armor, eventPlayer._hp_shields)
    eventPlayer.setHealth(eventPlayer.mercy_health)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.guardian_angel_cooldown)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_MERCY_VALKYRIE_COOLDOWN)

    eventPlayer.setAmmo(0, eventPlayer.caduceus_ammo)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

    wait(TICK_DURATION) # This is here so that you can set the ult charge, otherwise it wouldn't work.
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.setUltCharge(eventPlayer.valkyrie_ult_charge)

    eventPlayer.is_exiting_valkryie = false


rule "[mercy/valkyrie.opy]: Add ultimate charge while using valkyrie":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingUltimate() 

    eventPlayer.ult_point_while_ult_active = 0
    eventPlayer.start_time_ult = getTotalTimeElapsed()

    wait(0.1)
    waitUntil(not eventPlayer.is_exiting_valkryie, Math.INFINITY)
    # Check if the user did not switch hero after using Valkryie to add the ult charge
    if eventPlayer.getCurrentHero() == Hero.MERCY :
        # Add charge for passive generation and then the ult charge generated from the damage made by mercy
        eventPlayer._missing_ult_points = ULT_CHARGE_PER_SECOND * (getTotalTimeElapsed() - eventPlayer.start_time_ult) + eventPlayer.ult_point_while_ult_active


rule "[mercy/valkyrie.opy]: Calcul of the damage made while Valkyrie is active":
    @Event playerDealtDamage
    @Hero mercy
    @Condition eventPlayer.isUsingUltimate()
    @Condition victim != attacker

    if victim.getCurrentHero() in getTankHeroes() :
        eventPlayer.ult_point_while_ult_active += (1 + unpercent(OW2_TANK_ULT_NEGATION_PERCENT)) * eventDamage 
    else :
        eventPlayer.ult_point_while_ult_active += eventDamage

rule "[mercy/valkyrie.opy]: Calcul of the healing made while Valkyrie is active":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.ult_point_while_ult_active += eventHealing