#!mainFile "../../dev_main.opy"

# Logic by: https://workshop.codes/KEEY6

playervar concussive_cooldown
playervar concussive_charges

# rule "[pharah/concussive.opy]: Concussive Blast victims take no knockback":
#     @Event playerDealtDamage
#     @Hero pharah
#     @Condition eventAbility == Button.ABILITY_2

#     victim.setKnockbackReceived(0)
#     wait(OW1_PHARAH_CONCUSSIVE_BLAST_VICTIM_KNOCKBACK_REDUCTION_DURATION, Wait.ABORT_WHEN_FALSE)
#     victim.setKnockbackReceived(100)


rule "[pharah/strike.opy]: Concussive Blast charges":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.concussive_cooldown == OW1_PHARAH_CONCUSSIVE_BLAST_COOLDOWN
    
    waitUntil(eventPlayer.concussive_charges < OW1_PHARAH_CONUSSIVE_BLAST_MAX_CHARGE, Math.INFINITY)
    chaseOverTime(eventPlayer.concussive_cooldown, 0, OW1_PHARAH_CONCUSSIVE_BLAST_COOLDOWN)

    waitUntil(eventPlayer.concussive_cooldown == 0, Math.INFINITY)
    eventPlayer.concussive_charges += 1

    if ruleCondition: loop()


rule "[pharah/strike.opy]: If using Concussive Blast consume a charge":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.concussive_charges > 0
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2())
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.concussive_charges -= 1


rule "[pharah/strike.opy]: Start cooldown if zero charges":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.concussive_charges == 0

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.concussive_cooldown)


rule "[pharah/strike.opy]: Stop chasing variable if at max charge":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.concussive_charges == OW1_PHARAH_CONUSSIVE_BLAST_MAX_CHARGE
    
    eventPlayer.concussive_cooldown = OW1_PHARAH_CONCUSSIVE_BLAST_COOLDOWN
    stopChasingVariable(eventPlayer.concussive_cooldown)

    waitUntil(eventPlayer.concussive_charges < OW1_PHARAH_CONUSSIVE_BLAST_MAX_CHARGE, Math.INFINITY)
    chaseOverTime(eventPlayer.concussive_cooldown, 0, OW1_PHARAH_CONCUSSIVE_BLAST_COOLDOWN)