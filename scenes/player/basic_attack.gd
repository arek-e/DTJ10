extends HitEffect

## The base function
func trigger_damage() -> Attack:
	return roll_damage()


# Roll a d20 for damage, return the result as an Attack object
func roll_damage() -> Attack:
	var attack = Attack.new()
	attack.attack_damage = 5
	var crit_roll = randi() % 10 + 1  # Roll a d10
	if crit_roll == 10:
		attack.attack_damage = 10
	
	return attack
