#!mainFile "../../dev_main.opy"


def initWuyang():
    @Name "[wuyang/init.opy]: initWuyang()"

    setCustomHp(OW1_WUYANG_HEALTH, 0, 0)
    setUltCost(OW1_WUYANG_ULT_COST)
    # removeSelfHealing()

    setBaseDamage(eventPlayer, 0.75)
