#!mainFile "../../dev_main.opy"

#!include "strike.opy"
#!include "dragonstrike.opy"

def initGenji():
    @Name "[genji/init.opy]: initGenji()"
    
    setCustomHp(OW1_GENJI_HEALTH, 0, 0)
    setUltCost(OW1_GENJI_ULT_COST)
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)

    eventPlayer.swift_strike_cooldown = OW1_GENJI_SWIFT_STRIKE_COOLDOWN
    eventPlayer.swift_strike_charges = OW1_GENJI_MAX_SWIFT_STRIKE
    
    # removeSelfHealing()


rule "[genji/init.opy]: Deal OW1 shuriken damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    damage(victim, attacker, eventDamage*(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE)-eventDamage)
    

rule "[genji/init.opy]: Deal OW1 dash damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.ABILITY_1]

    heal(victim, null, OW2_GENJI_SWIFT_STRIKE_DAMAGE-OW1_GENJI_SWIFT_STRIKE_DAMAGE)