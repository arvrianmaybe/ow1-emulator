#!mainFile "../../dev_main.opy"

playervar storm_pvar
#!defineMember is_using_storm_arrow storm_pvar[0]
#!defineMember storm_arrow_hud_text storm_pvar[1]
playervar storm_arrow_buff_duration

macro showStormArrowDuration():
    if eventPlayer.storm_arrow_hud_text == null:
    createInWorldText(eventPlayer,
                    "{}".format(round(eventPlayer.storm_arrow_buff_duration)),
                    updateEveryTick(eventPlayer.getEyePosition() + (100 * (0 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((0.15 - 0.3) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()),
                    verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 1.5 * eventPlayer.getFacingDirection()))),
                    2,
                    Clip.NONE,
                    WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,\
                    Color.WHITE,
                    SpecVisibility.DEFAULT)
    eventPlayer.storm_arrow_hud_text = getLastCreatedText()

macro hideStormArrowDuration():
    destroyInWorldText(eventPlayer.storm_arrow_hud_text)
    eventPlayer.storm_arrow_hud_text = null

# rule "[hanzo/storm.opy]: OW1 storm arrow damage":
#     @Event playerDealtDamage
#     @Hero hanzo
#     @Condition eventAbility == Button.ABILITY_2

#     heal(victim, null, eventDamage - eventDamage*(OW1_HANZO_STORM_DAMAGE/OW2_HANZO_STORM_DAMAGE))


rule "[hanzo/storm.opy]: OW1 storm arrow buff":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.is_using_storm_arrow = true
    eventPlayer.storm_arrow_buff_duration = OW1_HANZO_STORM_ARROW_DURATION
    chase(eventPlayer.storm_arrow_buff_duration, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    showStormArrowDuration()
    eventPlayer.setDamageDealt(110)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_HANZO_STORM_COOLDOWN)
    wait(OW1_HANZO_STORM_ARROW_DURATION)
    eventPlayer.setDamageDealt(100)
    hideStormArrowDuration()
    eventPlayer.is_using_storm_arrow = false
    eventPlayer.setMoveSpeed(100)

rule "[hanzo/storm.opy]: Decrease Lunge cooldown":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.is_using_storm_arrow
    @Condition eventPlayer.getAbilityCooldown(Button.JUMP) > 0
   
    eventPlayer.setAbilityCooldown(Button.JUMP, 1)

rule "[hanzo/storm.opy]: No move penalty when shooting":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.is_using_storm_arrow

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW2_HANZO_BOW_PENALTY_SPEED)*(1+OW1_HANZO_BOW_PENALTY_SPEED))
    waitUntil(not eventPlayer.isFiringPrimaryFire() or not eventPlayer.is_using_storm_arrow, Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW2_HANZO_BOW_PENALTY_SPEED)/(1+OW1_HANZO_BOW_PENALTY_SPEED))