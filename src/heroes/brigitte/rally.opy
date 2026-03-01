#!mainFile "../../dev_main.opy"


playervar rally_pvar
#!defineMember rally_hot_id rally_pvar[0]
#!defineMember rally_armour_id rally_pvar[1]
#!defineMember rally_armour rally_pvar[2]


rule "[brigitte/rally.opy]: OW1 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR*eventPlayer._hp_scalar + OW2_ARMOR_DAMAGE_REDUCTION) # Remove Rally instant armor


    eventPlayer.rally_hot_id = getLastHoT()

    eventPlayer.rally_armour = eventPlayer.getHealthOfType(Health.ARMOR)
    waitUntil(not eventPlayer.isUsingUltimate(), OW1_BRIGITTE_RALLY_DURATION)

    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.rally_hot_id)


    # if eventPlayer.rally_armour > OW1_BRIGITTE_MAX_RALLY_ARMOUR:
    #     eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.rally_armour - (OW1_BRIGITTE_MAX_RALLY_ARMOUR/2), false, false)
    #     eventPlayer.rally_armour_id = getLastCreatedHealthPool()
    # else:
    #     eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.rally_armour, false, false)

    wait(OW1_RALLY_RALLY_ARMOUR_OVERHEALTH_DURATION)

    # removeHealthPool(eventPlayer.rally_armour_id)

    eventPlayer.removeAllHealthPools()

    
rule "[brigitte/rally.opy]: OW1 Rally Armor self":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    do:
        eventPlayer.rally_armour = eventPlayer.getHealthOfType(Health.ARMOR)

        wait(OW1_BRIGITTE_ALLY_RALLY_ARMOR_GAIN, Wait.ABORT_WHEN_FALSE)

        # if eventPlayer.rally_armour > OW1_BRIGITTE_MAX_RALLY_ARMOUR:
            # eventPlayer.addHealthPool(Health.ARMOR, OW1_BRIGITTE_RALLY_ARMOR_GAIN, false, false)
            getPlayersInRadius(eventPlayer.getPosition(), OW2_BRIGITTE_RALLY_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS).addHealthPool(Health.ARMOR, OW1_BRIGITTE_RALLY_ARMOR_GAIN, true)
            getPlayersInRadius(eventPlayer.getPosition(), OW2_BRIGITTE_RALLY_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES).setHealth(getPlayersInRadius(eventPlayer.getPosition(), OW2_BRIGITTE_RALLY_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES).getHealth() - OW1_BRIGITTE_RALLY_ARMOR_GAIN)
            # eventPlayer.rally_armour_id = getLastCreatedHealthPool()
        # else: return # Do nothing
    while RULE_CONDITION