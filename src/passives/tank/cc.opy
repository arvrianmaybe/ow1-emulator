#!mainFile "../../dev_main.opy"

# Workshop bug (doesn't work)

rule "[passives/tank/cc.opy]: Half Crowd Control for every Tank Hero":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in getTankHeroes() and not eventPlayer.getHero() == Hero.DOOMFIST
    @Condition isCCd(eventPlayer)

    if isHacked(eventPlayer):
        # wait(OW1_SOMBRA_HACK_ENEMY_DURATION/2, Wait.ABORT_WHEN_FALSE)
        # eventPlayer.clearStatusEffect(Status.HACKED)
        pass
    elif eventPlayer.hasStatusEffect(Status.FROZEN):
        wait(OW1_MEI_FREEZE_DURATION/2, Wait.ABORT_WHEN_FALSE)
        eventPlayer.clearStatusEffect(Status.FROZEN)
    elif eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN):
        wait(OW1_REINHARDT_EARTHSHATTER_KNOCK_DOWN_DURATION/2, Wait.ABORT_WHEN_FALSE) # Hard to do it for every hero so only did it for Earthshatter.
    elif eventPlayer.hasStatusEffect(Status.ASLEEP):
        wait(OW1_ANA_SLEEP_DART_SLEEP_DURATION/2, Wait.ABORT_WHEN_FALSE)
    elif eventPlayer.hasStatusEffect(Status.STUNNED):
        wait(OW1_BRIGITTE_SHIELD_BASH_STUN_DURATION/2, Wait.ABORT_WHEN_FALSE) # Hard to do it for every hero so only did it for Shield Bash.