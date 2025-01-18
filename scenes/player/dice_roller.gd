extends Node
class_name HitEffect

## The base function
func trigger_damage() -> float:
	return roll_damage()
	

# Roll a d20 for damage, return the result
func roll_damage() -> int:
	var dice_roll = randi() % 20 + 1  # Roll a d20
	if dice_roll == 20:
		print("Critical hit!")
		return 20  # Critical hit damage (you can adjust this)
	else:
		print("Hit", dice_roll)
		return dice_roll  # Normal hit damage
