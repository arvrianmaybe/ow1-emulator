#!mainFile "../../dev_main.opy"


def initDomina():
    @Name "[domina/init.opy]: initDomina()"

    setCustomHp(OW1_DOMINA_HEALTH, 0, OW1_DOMINA_SHIELDS)
    setUltCost(OW1_DOMINA_ULT_COST)
    # removeSelfHealing()
    
    setBaseDamage(eventPlayer, 0.7)