#!mainFile "../../dev_main.opy"


def initEmre():
    @Name "[emre/init.opy]: initEmre()"

    setCustomHp(OW1_EMRE_HEALTH, 0, 0)
    setUltCost(OW1_EMRE_ULT_COST)
    # removeSelfHealing()

    setBaseDamage(eventPlayer, 0.9)