#!mainFile "../../dev_main.opy"


playervar accretion_charge

rule "[sigma/accretion.opy]: Reset Accretion if hit rock":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition not eventPlayer.accretion_charge

    eventPlayer.accretion_charge = true
    waitUntil(not eventPlayer.isUsingAbility2())
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    wait(OW1_SIGMA_ACCRETION_COOLDOWN)
    eventPlayer.accretion_charge = false


rule "[sigma/accretion.opy]: OW1 accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage/eventPlayer._base_damage_scalar < OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # accretion is not direct hit

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SIGMA_ACCRETION_SPLASH_DAMAGE/OW2_SIGMA_ACCRETION_SPLASH_DAMAGE)-eventDamage)/eventPlayer._base_damage_scalar)