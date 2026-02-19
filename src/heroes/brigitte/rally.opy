#!mainFile "../../dev_main.opy"

playervar rally_pvar
#!defineMember rally_hot_id rally_pvar[0]
#!defineMember whipshot_spin rally_pvar[1]
playervar rally_duration


rule "[brigitte/rally.opy]: OW1 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.rally_duration = OW1_BRIGITTE_RALLY_DURATION
    chase(eventPlayer.rally_duration, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)

    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during rally
    damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR*eventPlayer._hp_scalar + OW2_ARMOR_DAMAGE_REDUCTION) # Remove Rally instant armor
    eventPlayer.startHoT(null, Math.INFINITY, OW1_BRIGITTE_RALLY_HEAL_RATE)
    eventPlayer.rally_hot_id = getLastHoT()

    waitUntil(not eventPlayer.isUsingUltimate(), OW1_BRIGITTE_RALLY_DURATION)

    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.rally_hot_id)


rule "[brigitte/rally.opy]: Detect if using Whipshot":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.whipshot_spin = true
    eventPlayer.setDamageDealt(30)
    eventPlayer.setKnockbackDealt(30)


    # Based off mitsiee https://workshop.codes/2S23V
    eventPlayer.startCamera(raycast(eventPlayer, worldVector(vect(0, 3, -5), 
        eventPlayer, Transform.ROTATION) + eventPlayer, getAllPlayers(), 
        eventPlayer, true).getHitPosition(), eventPlayer + worldVector(vect(0, 0, 5), 
        eventPlayer, 
        Transform.ROTATION), 1000)

    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Lose movement control
    wait(OW1_BRIGITTE_RALLY_MOVEMENT_RESTRICTION)
    eventPlayer.whipshot_spin = false
    eventPlayer.stopForcingThrottle()
    eventPlayer.stopFacing()
    eventPlayer.stopCamera()
    wait(1)
    setBaseDamage(eventPlayer, OW1_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE)
    eventPlayer.setKnockbackDealt(100)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.rally_duration + OW1_BRIGITTE_RALLY_WHIPSHOT_COOLDOWN - 1)

rule "[brigitte/rally.opy]: Force Whipshot to replicate spin":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.whipshot_spin
    @Condition not isCCd(eventPlayer)

    do:

        # Taken from https://workshop.codes/Q845R
        eventPlayer.startFacing(updateEveryFrame(directionTowards(eventPlayer.getEyePosition(), 
            eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).getEyePosition())), 1000)

        wait(OW1_BRIGITTE_RALLY_MOVEMENT_RESTRICTION/3)
        eventPlayer.cancelPrimaryAction()
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    while RULE_CONDITION


# rule "[brigitte/rally.opy]: Whipshot spin if Rally":
#     @Event eachPlayer
#     @Hero brigitte
#     @Condition eventPlayer.isUsingUltimate()
#     @Condition eventPlayer.whipshot_spin
    
#     do:
#         eventPlayer.setFacing(Vector.FORWARD, Relativity.TO_WORLD) # Ugliest code ive ever made but this is probably the only way
#         wait(OW1_BRIGITTE_RALLY_MOVEMENT_RESTRICTION/4)
#         eventPlayer.setFacing(Vector.LEFT, Relativity.TO_WORLD)
#         wait(OW1_BRIGITTE_RALLY_MOVEMENT_RESTRICTION/4)
#         eventPlayer.setFacing(Vector.BACKWARD, Relativity.TO_WORLD)
#         wait(OW1_BRIGITTE_RALLY_MOVEMENT_RESTRICTION/4)
#         eventPlayer.setFacing(Vector.RIGHT, Relativity.TO_WORLD)
#     while RULE_CONDITION