#!mainFile "../../dev_main.opy"


def initAnran():
    @Name "[anran/init.opy]: initAnran()"

    setCustomHp(OW1_ANRAN_HEALTH, 0, 0)
    setUltCost(OW1_ANRAN_ULT_COST)
    # removeSelfHealing()

    setBaseDamage(eventPlayer, 0.9)