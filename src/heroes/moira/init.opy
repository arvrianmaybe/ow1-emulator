#!mainFile "../../dev_main.opy"

#!include "heroes/moira/biotic_grasp.opy"
#!include "heroes/moira/biotic_orb.opy"
#!include "heroes/moira/coalescence.opy"


def initMoira():
    @Name "[moira/init.opy]: initMoira()"
    
    setCustomHp(OW1_MOIRA_HEALTH, 0, 0)
    setUltCost(OW1_MOIRA_ULT_COST)
    
    removePassiveHealing()



