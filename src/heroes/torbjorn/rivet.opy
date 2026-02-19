#!mainFile "../../dev_main.opy"


playervar rivet_gun_damage


rule "[torbjorn/init.opy]: Increase Rivet Gun damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.getCurrentWeapon() == 1 # Not using Hammer

    eventPlayer.rivet_gun_damage += OW1_TORBJORN_RIVET_ADDITIONAL_DAMAGE
    damage(victim, attacker, eventPlayer.rivet_gun_damage)
    wait(OW1_TORBJORN_RIVET_GUN_DURATION, Wait.RESTART_WHEN_TRUE)
    eventPlayer.rivet_gun_damage = 0