#!mainFile "../../dev_main.opy"

playervar nano_boosted_allies
playervar nano_boosted_self

rule "[ana/nano.opy]: Damage players to detect Nano Boost":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingUltimate()

    damage((([player for player in getPlayers(eventPlayer.getTeam()) if player.getNormalizedHealth() > 0.5]).exclude(eventPlayer)), null, 0.01)
    eventPlayer.nano_boosted_self = true
    wait(OW1_ANA_NANO_BOOST_DURATION)
    eventPlayer.nano_boosted_self = false


rule "[ana/nano.opy]: Set Nano Boosted ally healing recieved":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    
    healee.nano_boosted_allies = true
    healee.setHealingReceived(percent(OW1_ANA_ALLIES_HEALING_RECIEVED*eventPlayer._base_healing_recieved_scalar))
    wait(OW1_ANA_NANO_BOOST_DURATION)
    healee.nano_boosted_allies = false
    healee.setHealingReceived(100)

rule "[ana/nano.opy]: Nano boosted allies reduce Ana Cooldown on Elimination":
    @Event playerEarnedElimination
    @Condition eventPlayer.nano_boosted_allies

    eventPlayer.nano_boosted_self.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - 1)
    eventPlayer.nano_boosted_self.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)