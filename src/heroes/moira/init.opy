#!mainFile "../../dev_main.opy"

#!include "biotic_grasp.opy"
#!include "biotic_orb.opy"
#!include "coalescence.opy"


def initMoira():
    @Name "[moira/init.opy]: initMoira()"
    
    setCustomHp(OW1_MOIRA_HEALTH, 0, 0)
    setUltCost(OW1_MOIRA_ULT_COST)
    
    # removePassiveHealing()


rule "[moira/init.opy]: Decrease Movement speed on victims on melee":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.MELEE

    victim.setMoveSpeed(70)
    wait(OW1_MOIRA_MELEE_MOVEMENT_REDUCTION_DURATION)
    victim.setMoveSpeed(100)
    wait(OW1_MOIRA_MELEE_MOVEMENT_REDUCTION_COOLDOWN) # Idk if this works but we ball