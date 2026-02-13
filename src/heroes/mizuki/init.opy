#!mainFile "../../dev_main.opy"


def initMizuki():
    @Name "[mizuki/init.opy]: initMizuki()"

    setCustomHp(OW1_MIZUKI_HEALTH, 0, 0)
    setUltCost(OW1_MIZUKI_ULT_COST)
    # removeSelfHealing()

    setBaseDamage(eventPlayer, 0.85)