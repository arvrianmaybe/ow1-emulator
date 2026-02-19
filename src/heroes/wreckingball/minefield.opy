#!mainFile "../../dev_main.opy"

playervar minefield_blind_id

rule "[wreckingball/init.opy]: Blind victims on minefield":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility in [Button.ULTIMATE]

    if (victim.minefield_blind_id == null):
    createEffect(victim, 
            Effect.ORB, 
            Color.BLACK, 
            updateEveryFrame(victim.getEyePosition()) + updateEveryFrame(victim.getFacingDirection()) * -0.2995, 
            1, 
            EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    victim.minefield_blind_id = getLastCreatedEntity()
    # Partially bugged due to workshop

    victim.startForcingOutlineFor(getAllPlayers(), false, Color.BLACK) # Partially bugged due to workshop
    smallMessage(victim, "Blinded")

    wait(OW1_WRECKING_BALL_MINEFIELD_BLIND_DURATION, Wait.RESTART_WHEN_TRUE)

    destroyEffect(victim.minefield_blind_id)
    victim.minefield_blind_id = null
    victim.stopForcingOutlineFor(getAllPlayers())