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
@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	animation_tree.active = true
	

func _process(delta: float) -> void:
	update_animation_parameters()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right") * SPEED
	velocity.x = move_toward(velocity.x, direction, ACCELERATION * delta)
	
	move_and_slide()
	
func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/PlayerStates/conditions/idle"] = true
		animation_tree["parameters/PlayerStates/conditions/is_moving"] = false
	else:
		animation_tree["parameters/PlayerStates/conditions/idle"] = false
		animation_tree["parameters/PlayerStates/conditions/is_moving"] = true

	if(Input.is_action_just_pressed("swing")):
		animation_tree["parameters/PlayerStates/conditions/throw"] = true
	else:
		animation_tree["parameters/PlayerStates/conditions/throw"] = false
		
