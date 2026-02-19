#!mainFile "../../dev_main.opy"

# !include "focusing_beam.opy"
#!include "duplicate.opy"


def initEcho():
    @Name "[echo/init.opy]: initEcho()"

    setCustomHp(OW1_ECHO_HEALTH-0.75, 0, 0)
    setUltCost(OW1_ECHO_ULT_COST)
    # removeSelfHealing()

rule "[echo/init.opy]: Heal Echo if did final blow":
    @Event playerDealtFinalBlow
    @Hero echo  

    eventPlayer.setHealth(eventPlayer.getHealth()*1.3)

rule "[echo/flight.opy]: 15% Glide speed":
    @Event eachPlayer
    @Hero echo
    @Condition not eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition eventPlayer.isInAir()
    @Condition eventPlayer.getAltitude() >= 0.5

    eventPlayer.setMoveSpeed(115)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround(), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)