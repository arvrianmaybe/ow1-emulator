#!mainFile "../../dev_main.opy"

playervar ralley_hot_id
playervar shield_bash_cd

rule "[brigitte/rally.opy]: OW1 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()


    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, eventPlayer.shield_bash_cd)
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR*eventPlayer._hp_scalar + OW2_ARMOR_DAMAGE_REDUCTION) # Remove Rally instant armor


    eventPlayer.ralley_hot_id = getLastHoT()

    eventPlayer.A = eventPlayer.getHealthOfType(Health.ARMOR)
    waitUntil(not eventPlayer.isUsingUltimate(), 10)


    if eventPlayer.A > 100:
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.A - 50, false, false)
    else:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.A, false, false)
    wait(30)
    removeHealthPool(getLastCreatedHealthPool())
    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.ralley_hot_id)


rule "[brigitte/rally.opy]: Track Bash cooldown":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isFiringSecondaryFire()
        
    eventPlayer.shield_bash_cd = OW1_BRIGITTE_SHIELD_BASH_COOLDOWN
    chase(eventPlayer.shield_bash_cd, 0, rate=1, ChaseReeval.NONE)


rule "[brigitte/rally.opy]: Force cooldown for Bash in Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()
    
    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, eventPlayer.shield_bash_cd)