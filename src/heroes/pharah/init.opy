#!mainFile "../../dev_main.opy"

#!include "heroes/pharah/hover_jets.opy"
#!include "heroes/pharah/rocket_launcher.opy"
#!include "heroes/pharah/concussive.opy"


def initPharah():
    @Name "[pharah/init.opy]: initPharah()"

    setCustomHp(OW1_PHARAH_HEALTH, 0, 0)
    setUltCost(OW1_PHARAH_ULT_COST)
    removeSelfHealing()

    initHoverJets()


rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer._call_init

    initPharah()
    eventPlayer._call_init = false


rule "[pharah/init.opy]: Clean up Pharah":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.PHARAH
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.PHARAH, Math.INFINITY)
    hideFuelGui()
