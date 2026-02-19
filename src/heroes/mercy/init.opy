#!mainFile "../../dev_main.opy"

#!include "guardian.opy"
#!include "resurrect.opy"
#!include "regeneration.opy"
#!include "valkyrie.opy"


def initMercy():
    @Name "[mercy/init.opy]: initMercy()"
    
    setCustomHp(OW1_MERCY_HEALTH, 0, 0)
    setUltCost(OW1_MERCY_ULT_COST)
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

    setBaseHealing(eventPlayer, OW1_MERCY_STAFF_HEALING/OW2_MERCY_STAFF_HEALING)

    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false
    eventPlayer.is_exiting_valkryie = false
