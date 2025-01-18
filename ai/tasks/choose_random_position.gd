extends BTAction

@export var range_min_in_dir: float = 40.0
@export var range_max_in_dir: float = 100.0

@export var position_var: StringName = &"pos"
@export var direction_var: StringName = &"dir"


func _tick(delta: float) -> Status:
	var pos: Vector2
	var dir = rando_dir()
	
	pos = rando_pos(dir)
	blackboard.set_var(position_var, pos)
	
	return SUCCESS
	
	
func rando_dir():
	var dir = randi_range(-2, 1)
	if abs(dir) != dir:
		dir = -1
	else:
		dir = 1
	blackboard.set_var(direction_var, dir)
	return dir
	
func rando_pos(dir: int):
	var vector: Vector2
	var distance = randi_range(range_min_in_dir, range_max_in_dir) * dir
	var final_position = (distance + agent.global_position.x)
	vector.x = final_position
	return vector
	
