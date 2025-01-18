extends Node2D

const LIMIT_LEFT = -315
const LIMIT_TOP = -250
const LIMIT_RIGHT = 955
const LIMIT_BOTTOM = 690

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
