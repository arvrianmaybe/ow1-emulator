#!mainFile "../../dev_main.opy"

#!include "heroes/dva/hp.opy"
#!include "heroes/dva/gun.opy"
#!include "heroes/dva/booster.opy"
#!include "heroes/dva/bomb.opy"


def initDva():
    @Name "[dva/init.opy]: initDva()"
    
    setUltCost(OW1_DVA_ULT_COST)
    removeTankPassive()
    removeSelfHealing()


rule "[dva/init.opy]: Initialize DVa":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer._call_init

    initDva()
    eventPlayer._call_init = false
