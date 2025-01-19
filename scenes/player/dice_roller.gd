extends Node
class_name HitEffect

## The base function
func trigger_damage() -> Attack:
	return roll_damage()


# Roll a d20 for damage, return the result as an Attack object
# Roll a d20 for damage, return the result as an Attack object
func roll_damage() -> Attack:
	var attack = Attack.new()
	var dice_roll = randi() % 20 + 1  # Roll a d20
	var is_critical = false
	var damage = 0

	if dice_roll == 20:
		# Critical hit
		print("Critical hit!")
		is_critical = true
		damage = 20  # Critical hit damage
	elif dice_roll < 10:
		# Flat damage for rolls below 10
		print("Flat damage: ", dice_roll)
		damage = 5  # Flat damage (you can adjust this value)
	else:
		# Slightly more damage for rolls above 10 but below 20
		print("Slightly more damage: ", dice_roll)
		damage = randi() % 10 + 6  # Randomized damage between 6 and 15

	# Set the values in the attack object
	attack.attack_damage = damage
	attack.is_critical_hit = is_critical

	return attack
