#!mainFile "../../dev_main.opy"


rule "[passives/tank/damage.opy]: Half damage for every Tank Hero":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in getTankHeroes() and not eventPlayer.getHero() == Hero.DOOMFIST

    eventPlayer.setDamageDealt(100-TANK_DAMAGE_REDUCTION)
    wait(3)
    if RULE_CONDITION: goto RULE_START