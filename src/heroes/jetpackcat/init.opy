#!mainFile "../../dev_main.opy"


def initJetpackCat():
    @Name "[jetpackcat/init.opy]: initJetpackCat()"

    setCustomHp(OW1_JETPACK_CAT_HEALTH, 0, 0)
    setUltCost(OW1_JETPACK_CAT_ULT_COST)
    # removeSelfHealing()