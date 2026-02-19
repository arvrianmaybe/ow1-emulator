#!mainFile "../../dev_main.opy"

playervar stealth_pvar
#!defineMember is_using_stealth stealth_pvar[0]
#!defineMember _stealth_hud_id stealth_pvar[1]
#!defineMember _stealth_hud_progress_id stealth_pvar[3]

playervar stealth_timer

subroutine enterStealth
subroutine exitStealth
subroutine showStealthHud

rule "[sombra/stealth.opy]: Bind Ability 1 to stealth":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.is_using_stealth

    enterStealth()


def enterStealth():
    @Name "[sombra/stealth.opy]: enterStealth()"

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setSecondaryFireEnabled(false) # Disable hacking during invis
    wait(OW1_SOMBRA_STEALTH_CAST_TIME)
    showStealthHud()
    eventPlayer.setInvisibility(Invis.ENEMIES)
    eventPlayer.setMoveSpeed(percent(OW1_SOMBRA_STEALTH_MOVEMENT_BONUS))
    eventPlayer.is_using_stealth = true
    eventPlayer.setGravity(0)
    wait(OW1_SOMBRA_STEALTH_DURATION)
    eventPlayer.setGravity(100)
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.setMoveSpeed(percent(OW1_SOMBRA_STEALTH_MOVEMENT_BONUS/OW2_SOMBRA_STEALTH_MOVEMENT_BONUS))
    exitStealth()


rule "[sombra/stealth.opy]: Exit Stealth when shooting":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.is_using_stealth
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) \
            or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) \
            or eventPlayer.isHoldingButton(Button.MELEE) \
            or eventPlayer.isHoldingButton(Button.ABILITY_1) \
            or eventPlayer.isHoldingButton(Button.ULTIMATE)

    exitStealth()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_SOMBRA_STEALTH_COOLDOWN)


rule "[sombra/stealth.opy]: Exit Stealth when taking damage":
    @Event playerTookDamage
    @Hero sombra
    @Condition eventPlayer.is_using_stealth

    exitStealth()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_SOMBRA_STEALTH_COOLDOWN)


def exitStealth():
    @Name "[sombra/stealth.opy]: exitStealth()"

    destroyEffect(eventPlayer._stealth_hud_id)
    eventPlayer._stealth_hud_id = null
    
    destroyProgressBarInWorldText(eventPlayer._stealth_hud_progress_id)
    eventPlayer._stealth_hud_progress_id = null

    stopChasingVariable(eventPlayer.stealth_timer)

    eventPlayer.setSecondaryFireEnabled(true) # Enable hacking after exiting invis
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setGravity(100)
    wait(OW1_SOMBRA_STEALTH_RECOVERY_TIME)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_SOMBRA_STEALTH_COOLDOWN)
    eventPlayer.is_using_stealth = false


def showStealthHud():
    @Name "[sombra/stealth.opy]: showStealthHud()"

    eventPlayer.stealth_timer = 100
    chase(eventPlayer.stealth_timer, 0, rate=12.5, ChaseReeval.DESTINATION_AND_RATE)

    
    if eventPlayer._stealth_hud_id == null:
        createEffect(eventPlayer, Effect.SPHERE, rgb(100, 68, 179), eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._stealth_hud_id = getLastCreatedEntity()

    if eventPlayer._stealth_hud_progress_id == null:
        createProgressBarInWorldText(eventPlayer, eventPlayer.stealth_timer, "INVISIBLE", 
            updateEveryTick(eventPlayer.getEyePosition() + ((angleToDirection(eventPlayer.getHorizontalFacingAngle(), eventPlayer.getVerticalFacingAngle() + -18)) * 50)), 
            1, 
            Clip.NONE, 
            Color.PURPLE, 
            Color.WHITE, 
            ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, 
            SpecVisibility.DEFAULT)
    eventPlayer._stealth_hud_progress_id = getLastCreatedText()

rule "[sombra/stealth.opy]: Fix gravity when falling in stealth":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.is_using_stealth
    @Condition eventPlayer.getAltitude() > 0.05
    @Condition distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 4 * Vector.DOWN, null, null, false).getHitPosition()) > 1.3

    do:
        eventPlayer.applyImpulse(Vector.DOWN, 0.555, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION


rule "[sombra/stealth.opy]: No sound walking + height in stealth":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.is_using_stealth
    @Condition distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 4 * Vector.DOWN, null, null, false).getHitPosition()) < 1.2

     eventPlayer.applyImpulse(Vector.UP, distance(eventPlayer.getEyePosition(), 
        raycast(eventPlayer.getEyePosition(), 
        eventPlayer.getEyePosition() + 4 * Vector.DOWN, 
        null, 
        null, 
        false).getHitPosition()) * 
        2, 
        Relativity.TO_WORLD, 
        Impulse.CANCEL_CONTRARY_MOTION_XYZ)
     waitUntil(distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 4 * Vector.DOWN, null, null, false).getHitPosition()) >= 1.3, 0.5)
     eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getVerticalSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "[sombra/stealth.opy]: Replicate jumping if stealth":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.is_using_stealth
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    if eventPlayer.is_using_stealth and eventPlayer.getAltitude() < 0.05:
        eventPlayer.applyImpulse(Vector.UP, 5.72, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

rule "[sombra/stealth.opy]: Fix movement is not moving":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.is_using_stealth
    @Condition distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 4 * Vector.DOWN, null, null, false).getHitPosition()) < 1.35

    do:
        eventPlayer.applyImpulse(worldVector(eventPlayer.getThrottle(), 
            eventPlayer, 
            Transform.ROTATION) if distance(vect(0, 0, 0), 
            eventPlayer.getThrottle()) > 0.01 else (vect(eventPlayer.getVelocity().x, 0, eventPlayer.getVelocity().z) * -1), 
            (min(1, magnitude(eventPlayer.getThrottle())) * (5.5 * (OW1_SOMBRA_STEALTH_MOVEMENT_BONUS * 0.01)) * 0.9 if eventPlayer.getThrottle().z < 0 else 5.5 * 
            (OW1_SOMBRA_STEALTH_MOVEMENT_BONUS * 0.01)) - max(0, min((5.5 * (OW1_SOMBRA_STEALTH_MOVEMENT_BONUS * 0.01)) * 0.9 if eventPlayer.getThrottle().z < 0 else 5.5 * 
            (OW1_SOMBRA_STEALTH_MOVEMENT_BONUS * 0.01), 
            eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), 
            eventPlayer, 
            Transform.ROTATION)))) if distance(vect(0, 0, 0), 
            eventPlayer.getThrottle()) > 0.01 else eventPlayer.getHorizontalSpeed(), 
            Relativity.TO_WORLD, 
            Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION