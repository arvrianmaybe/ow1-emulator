#!mainFile "../../dev_main.opy"

#!include "heroes/zarya/self_bubble.opy"
#!include "heroes/zarya/ally_bubble.opy"


def initZarya():
    @Name "[zarya/init.opy]: initZarya()"

    setCustomHp(OW1_ZARYA_HEALTH, 0, OW1_ZARYA_SHIELDS)
    setUltCost(OW1_ZARYA_ULT_COST)
    setBaseDamage(eventPlayer, OW1_ZARYA_CANNON_DAMAGE_MAX/OW2_ZARYA_CANNON_DAMAGE_MAX)
    removeSelfHealing()
    removeTankPassive()

    initSelfBubble()
    initAllyBubble()


# rule "[zarya/init.opy]: Initialize Zarya":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition not eventPlayer._is_exiting_wholehog # guards against initialization when exiting wholehog

#     resetHero()
#     async(initZarya, AsyncBehavior.RESTART)


rule "[zarya/init.opy]: Clean up Zarya":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ZARYA

    waitUntil(eventPlayer.getCurrentHero() != Hero.ZARYA, Math.INFINITY)
    hideSelfBubbleCD()
    hideAllyBubbleCD()


rule "[zarya/init.opy]: Compensate zarya global damage reduction":
    @Event playerDealtDamage
    @Hero zarya
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
