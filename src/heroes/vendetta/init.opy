#!mainFile "../../dev_main.opy"


def initVendetta():
    @Name "[vendetta/init.opy]: initVendetta()"

    setCustomHp(OW1_VENDETTA_HEALTH, OW1_VENDETTA_ARMOR, 0)
    setUltCost(OW1_VENDETTA_ULT_COST)
    # removeSelfHealing()

    setBaseDamage(eventPlayer, 200/225)