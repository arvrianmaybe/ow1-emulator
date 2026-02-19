#!mainFile "../../dev_main.opy"


rule "[sombra/hack.opy]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(eventPlayer.enemy_sombra_player, Status.HACKED, OW1_SOMBRA_HACK_ENEMY_DURATION)
    eventPlayer.hack_timer = OW1_SOMBRA_HACK_ENEMY_DURATION
    chase(eventPlayer.hack_timer, 0, rate=1, ChaseReeval.NONE)


rule "[sombra/hack.opy]: OW1 Hack Interruption cooldown":
    @Event playerTookDamage
    @Hero sombra
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_SOMBRA_HACK_INTERRUPT_COOLDOWN)
    eventPlayer.setSecondaryFireEnabled(true)