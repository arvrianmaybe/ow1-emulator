#!mainFile "../../dev_main.opy"

#!include "heroes/mercy/guardian.opy"


def initMercy():
    @Name "[mercy/init.opy]: initMercy()"
    
    setCustomHp(OW1_MERCY_HEALTH, 0, 0)
    setUltCost(OW1_MERCY_ULT_COST)
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false

rule "[mercy/init.opy]: Initialize Mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer._call_init

    initMercy()
    eventPlayer._call_init = false
