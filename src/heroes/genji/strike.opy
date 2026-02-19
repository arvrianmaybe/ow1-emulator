#!mainFile "../../dev_main.opy"

# Logic by: https://workshop.codes/KEEY6


playervar swift_strike_cooldown
playervar swift_strike_charges


rule "[genji/strike.opy]: Swift Strike charges":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.swift_strike_cooldown == OW1_GENJI_SWIFT_STRIKE_COOLDOWN
    
    waitUntil(eventPlayer.swift_strike_charges < OW1_GENJI_MAX_SWIFT_STRIKE, Math.INFINITY)
    chaseOverTime(eventPlayer.swift_strike_cooldown, 0, OW1_GENJI_SWIFT_STRIKE_COOLDOWN)

    waitUntil(eventPlayer.swift_strike_cooldown == 0, Math.INFINITY)
    eventPlayer.swift_strike_charges += 1

    if ruleCondition: loop()


rule "[genji/strike.opy]: If using Swift Strike consume a charge":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.swift_strike_charges > 0
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1())
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.swift_strike_charges -= 1


rule "[genji/strike.opy]: Start cooldown if zero charges":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.swift_strike_charges == 0

    do:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.swift_strike_cooldown)
        wait()
    while RULE_CONDITION

    if eventPlayer.swift_strike_charges == 1:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0) # It shows a cooldown but it still works if you press it


rule "[genji/strike.opy]: Add Swift Strike charge if you kill someone":
    @Event playerEarnedElimination
    @Hero genji
    
    if eventPlayer.swift_strike_charges == OW1_GENJI_MAX_SWIFT_STRIKE: return
    else: eventPlayer.swift_strike_charges += 1


rule "[genji/strike.opy]: Stop chasing variable if at max charge":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.swift_strike_charges == OW1_GENJI_MAX_SWIFT_STRIKE
    
    eventPlayer.swift_strike_cooldown = OW1_GENJI_SWIFT_STRIKE_COOLDOWN
    stopChasingVariable(eventPlayer.swift_strike_cooldown)

    waitUntil(eventPlayer.swift_strike_charges < OW1_GENJI_MAX_SWIFT_STRIKE, Math.INFINITY)
    chaseOverTime(eventPlayer.swift_strike_cooldown, 0, OW1_GENJI_SWIFT_STRIKE_COOLDOWN)