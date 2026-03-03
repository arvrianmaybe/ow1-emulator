#!mainFile "../../dev_main.opy"

rule "[mercy/regeneration.opy]: Start Passive regeneration self-heal":
    @Event playerTookDamage
    @Hero mercy

    eventPlayer.stopAllHoT()
    wait(OW1_MERCY_REGENERATION_START - TICK_DURATION, Wait.RESTART_WHEN_TRUE)
    eventPlayer.startHoT(eventPlayer, Math.INFINITY, OW1_MERCY_REGENERATION_PASSIVE_HPS)

rule "[mercy/regeneration.opy]: Detect if under max hp for Passive regeneration":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    
    waitUntil(eventPlayer.getHealth() == eventPlayer.getMaxHealth())
    eventPlayer.stopAllHoT()