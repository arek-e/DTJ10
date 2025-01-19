class_name Player
extends CharacterBody2D

@export_range(0, 1) var decalerate_on_jump_release = 0.5
@export var dash_speed = 5.0
@export var dash_max_distance = 75.0
@export var dash_curve: Curve
@export var dash_cooldown = 1.0


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
@onready var jump_particles = $JumpParticles

@export var is_attacking = false
var is_dashing = false
var dash_starting_position = 0
var dash_direction = 0
var dash_timer = 0

var footstep_frames: Array = []

# Double jump variables
var jump_count = 0
const MAX_JUMPS = 1  # Allow up to two jumps (regular + double jump)


func _ready() -> void:
	animation_tree.active = true
	jump_count = 0  


func _process(delta: float) -> void:
	update_animation_parameters()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("move_left", "move_right") * SPEED

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():  # First jump (normal)
			velocity.y = JUMP_VELOCITY
			jump_count = 1  # Count first jump
			jump_particles.restart()
			jump_particles.emitting = true
			
		elif jump_count < MAX_JUMPS:  # Second jump (double jump)
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decalerate_on_jump_release
		
	# Handle dash.
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_starting_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		animation_tree["parameters/PlayerStates/conditions/is_dashing"] = true
		
	if is_dashing:
		var current_distance = abs(position.x - dash_starting_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
			animation_tree["parameters/PlayerStates/conditions/is_dashing"] = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
		
	if dash_timer > 0:
		dash_timer -= delta
	
	# Reset jump count when the player is back on the floor
	if is_on_floor():
		jump_count = 0

	# Gradual deceleration when attacking
	if is_attacking:
		# Apply gradual deceleration during attack
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta * 0.5)  # Adjust the 0.5 factor for deceleration speed
	else:
		# Normal movement if not attacking
		velocity.x = move_toward(velocity.x, direction, ACCELERATION * delta)

	# Stop movement if attacking, but decelerate gradually
	if not is_attacking and direction == 0:
		# If not attacking and no input, decelerate normally
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		
	floor_stop_on_slope = not platform_detector.is_colliding()

	move_and_slide()
	
func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/PlayerStates/conditions/idle"] = true
		animation_tree["parameters/PlayerStates/conditions/is_moving"] = false
	else:
		animation_tree["parameters/PlayerStates/conditions/idle"] = false
		animation_tree["parameters/PlayerStates/conditions/is_moving"] = true

	if(Input.is_action_just_pressed("swing")):
		if is_on_floor():
			animation_tree["parameters/PlayerStates/conditions/throw"] = true
	else:
		animation_tree["parameters/PlayerStates/conditions/throw"] = false
