#!mainFile "../../dev_main.opy"


rule "[pharah/concussive.opy]: Remove OW2 Concussive Blast damage":
    @Event playerDealtDamage
    @Hero pharah
    @Condition eventAbility == Button.ABILITY_2

    heal(victim, null, eventDamage)


rule "[pharah/rocket_launcher.opy]: OW1 Concussive Blast Projectile speed":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setProjectileSpeed(100)
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.setProjectileSpeed(percent(OW1_PHARAH_ROCKET_SPEED/OW2_PHARAH_ROCKET_SPEED))