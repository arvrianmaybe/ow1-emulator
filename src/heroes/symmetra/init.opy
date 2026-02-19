#!mainFile "../../dev_main.opy"

#!include "projector.opy"
#!include "orb.opy"
#!include "teleporter.opy"


def initSymmetra():
    @Name "[symmetra/init.opy]: initSymmetra()"

    setCustomHp(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    setUltCost(OW1_SYMMETRA_ULT_COST)
    # removeSelfHealing()

    eventPlayer.setAmmo(0, OW1_SYMMETRA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_SYMMETRA_CLIP_SIZE)


rule "[symmetra/init.opy]: Correct Photon Projector damage":
    @Event playerDealtDamage
    @Hero symmetra
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(victim, null, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SYMMETRA_SECONDARY_PROJECTOR/OW2_SYMMETRA_SECONDARY_PROJECTOR)-eventDamage)/eventPlayer._base_damage_scalar)
