#!mainFile "../../dev_main.opy"


playervar halt_pvar
#!defineMember snared_victims halt_pvar[0]
#!defineMember is_using_halt halt_pvar[1]
#!defineMember halt_snare_line_id halt_pvar[2]

subroutine showSnareLine
subroutine hideSnareLine


def showSnareLine():
    @Name "[orisa/halt.opy]: showSnareLine()"

    if (eventPlayer.halt_snare_line_id == null):
    createBeam(getAllPlayers(), 
        Beam.BAD, 
        eventPlayer.enemy_orisa_player, 
        eventPlayer.getPosition(), 
        Color.GREEN, 
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.halt_snare_line_id = getLastCreatedEntity()


def hideSnareLine():
    @Name "[orisa/halt.opy]: hideSnareLine()"

    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null


rule "[orisa/halt.opy]: Enable Halt to know nearby victims":
    @Event eachPlayer
    @Hero orisa
    @Condition getPlayersInRadius(eventPlayer.getPosition(), OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)

    eventPlayer.setSecondaryFireEnabled(true)
    waitUntil(not getPlayersInRadius(eventPlayer.getPosition(), OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES), Math.INFINITY)
    eventPlayer.setSecondaryFireEnabled(false)


rule "[orisa/halt.opy]: Detect nearby Halt victims":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0
    @Condition eventPlayer.isAlive()
    @Condition not isCCd(eventPlayer)
    @Condition getPlayersInRadius(eventPlayer.getPosition(), OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) # Detect nearby players to Orisa
    
    # waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), Math.INFINITY) # Ensure player releases right click

    eventPlayer.is_using_halt = true # Start halt

    # getPlayersInRadius(eventPlayer.getPosition(), 
    #     OW1_ORISA_HALT_AOE_RADIUS, 
    #     getOppositeTeam(eventPlayer.getTeam())).snared_victims = true # Detect nearby players in Orisa

    getClosestPlayer(eventPlayer, 
        getOppositeTeam(eventPlayer.getTeam())).snared_victims = true # Detect closest players to Orisa
    
    wait(OW1_ORISA_HALT_SNARE_DURATION)

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_ORISA_HALT_COOLDOWN_TIME)

    eventPlayer.is_using_halt = false # End halt


rule "[orisa/halt.opy]: Stop snared victims":
    @Event eachPlayer
    @Condition eventPlayer.snared_victims

    wait(OW1_ORISA_HALT_SNARE_DURATION)
    eventPlayer.snared_victims = false


rule "[orisa/halt.opy]: Slow down halted Victims":
    @Event eachPlayer
    @Condition eventPlayer.snared_victims

    eventPlayer.setMoveSpeed(100-OW1_ORISA_HALT_SNARE_MOVE_PENALTY)
    cancelMomentum(eventPlayer)

    wait(OW1_ORISA_HALT_SNARE_DURATION)

    eventPlayer.setMoveSpeed(100)


rule "[orisa/halt.opy]: Pull halted Victims to Orisa": # More robust solution
    @Event eachPlayer
    @Condition eventPlayer.snared_victims

    do:
        eventPlayer.applyImpulse(directionTowards(eventPlayer, eventPlayer.enemy_orisa_player), 3, Relativity.TO_WORLD)
        wait()
    while RULE_CONDITION


rule "[orisa/halt.opy]: Halt snare line VFX":
    @Event eachPlayer
    @Condition eventPlayer.snared_victims

    # Halt orb explosion sounds
    showSnareLine()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.LIME_GREEN, eventPlayer, 100)
    
    wait(OW1_ORISA_HALT_SNARE_DURATION)

    hideSnareLine()
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer, 100)