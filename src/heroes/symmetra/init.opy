#!mainFile "../../dev_main.opy"

#!include "heroes/symmetra/projector.opy"
#!include "heroes/symmetra/orb.opy"
#!include "heroes/symmetra/teleporter.opy"


def initSymmetra():
    @Name "[symmetra/init.opy]: initSymmetra()"

    setCustomHp(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    setUltCost(OW1_SYMMETRA_ULT_COST)
    removeSelfHealing()


rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer._call_init

    initSymmetra()
    eventPlayer._call_init = false
