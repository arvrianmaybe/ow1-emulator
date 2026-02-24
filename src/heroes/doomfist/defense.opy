#!mainFile "../../dev_main.opy"

# Code is heavily based off https://workshop.codes/C9WF3
# created by discord user: Spiderman31807

playervar defense_pvar
#!defineMember current_health defense_pvar[0]
#!defineMember ow1_best_defense_shields defense_pvar[1]
#!defineMember current_best_defense_shields defense_pvar[2]
#!defineMember ow2_best_defense_overhealth defense_pvar[3]

macro storedDefenseHealth():
    eventPlayer.current_health = eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) 


rule "[doomfist/defense.opy]: Override OW2 Best defense":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) > 0
    @Condition not eventPlayer.getHealthOfType(Health.SHIELDS)

    do:
        storedDefenseHealth()
        eventPlayer.ow2_best_defense_overhealth = eventPlayer.getHealth() - eventPlayer.current_health # Detect OW2 best defense
        eventPlayer.setHealth(eventPlayer.ow2_best_defense_overhealth) # Overwrite OW2 best defense
        wait()
    while RULE_CONDITION

    # eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.ow1_best_defense_shields, false, false)


rule "[doomfist/defense.opy]: Custom OW1 Best defense":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE, Button.ABILITY_1] and not eventPlayer.wall_impacted_victims or eventPlayer.is_using_uppercut
    # @Condition not eventPlayer.ow1_best_defense_shields > OW1_DOOMFIST_BEST_DEFENSE_MAX_SHIELDS
    
    storedDefenseHealth()
    eventPlayer.ow2_best_defense_overhealth = eventPlayer.getHealth() - eventPlayer.current_health # Detect OW2 best defense

    eventPlayer.current_best_defense_shields = eventPlayer.getHealthOfType(Health.SHIELDS)
    eventPlayer.setHealth(eventPlayer.ow2_best_defense_overhealth)

    if eventAbility == Button.ULTIMATE: # Meteor Strike shields
        eventPlayer.ow1_best_defense_shields = OW1_DOOMFIST_BEST_DEFENSE_ULTIMATE + eventPlayer.current_best_defense_shields
    else: # Slam, Punch, Uppercut shields
        eventPlayer.ow1_best_defense_shields = OW1_DOOMFIST_BEST_DEFENSE + eventPlayer.current_best_defense_shields

    eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.ow1_best_defense_shields, false, false)
    
    if eventPlayer.getHealthOfType(Health.SHIELDS) > eventPlayer.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX_SHIELDS: # Correct shields if over max shields limit
        removeHealthPool(getLastCreatedHealthPool())
        eventPlayer.addHealthPool(Health.SHIELDS, OW1_DOOMFIST_BEST_DEFENSE_MAX_SHIELDS, false, false)
        return


rule "[doomfist/defense.opy] Decay Best Defense shields": # Logic by Alomare: https://workshop.codes/E1EW0
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS)
    # @Condition eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) > 0
    
    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER, Wait.RESTART_WHEN_TRUE)
    storedDefenseHealth()
    wait() # Try prevent crashes as much as possible
    while eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) > 0:
        if eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL)  > eventPlayer.current_health:
            loop()
        if eventPlayer.getHealth() < eventPlayer.getMaxHealth():
            eventPlayer.ow2_best_defense_overhealth = eventPlayer.getHealth() - eventPlayer.current_health
            while eventPlayer.getHealth() > eventPlayer.ow2_best_defense_overhealth:
                eventPlayer.setHealth(eventPlayer.ow2_best_defense_overhealth)
            eventPlayer.current_health -= OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE
            if eventPlayer.current_health < 1:
                return
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.current_health, false, false)
        else:
            eventPlayer.setHealth(eventPlayer.getHealth() - OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
            storedDefenseHealth()
        wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)