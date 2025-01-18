class_name Player
extends CharacterBody2D



const SPEED = 300.0
const ACCELERATION = SPEED * 6.0
const JUMP_VELOCITY = -400.0
const TERMINAL_VELOCITY = 380

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var sprite := $Sprite2D as Sprite2D
@onready var camera := $Camera as Camera2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right") * SPEED
	velocity.x = move_toward(velocity.x, direction, ACCELERATION * delta)

	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			sprite.scale.x = 1.0
		else:
			sprite.scale.x = -1.0
	
	move_and_slide()


func get_new_animation(is_swinging:= false) -> String:
	var animation_new: String
	
	if is_on_floor():
		if absf(velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		animation_new = "jumping"
	if is_swinging:
		animation_new += "_swinging"
	return animation_new
