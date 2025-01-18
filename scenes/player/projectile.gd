extends RigidBody2D

enum THROW_TYPE { STRAIGHT, ARC }

@export var throw_type: THROW_TYPE = THROW_TYPE.STRAIGHT
@export var SPEED: float = 100  # Constant speed for all directions
@export var GRAVITY: float = 300.0  # Gravity value for ARC mode
@export var INITIAL_BURST_SPEED: float = 300.0  # Initial burst of speed for momentum
@export var GRAVITY_DELAY: float = 0.1  # Time in seconds before gravity starts affecting the projectile
@export var AIR_RESISTANCE: float = 0.05  # Air resistance factor affecting x velocity (0-1, where 1 is high resistance)

var direction: Vector2 = Vector2.ZERO
var initial_velocity: Vector2 = Vector2.ZERO
var velocity_initial_burst: Vector2 = Vector2.ZERO
var gravity_timer: float = 0.0  # Timer to track when gravity should start applying

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the projectile is initialized
func initialize(position: Vector2, dir: Vector2) -> void:
	global_position = position
	direction = dir.normalized()  # Calculate direction towards mouse

	# Set initial burst velocity in direction of throw
	velocity_initial_burst = direction * INITIAL_BURST_SPEED

# Called when the projectile is ready
func _ready() -> void:
	# Start playing the default animation
	if animated_sprite:
		animated_sprite.play()

# Physics process for handling gravity and air resistance
func _physics_process(delta: float) -> void:
	# Increment gravity timer
	gravity_timer += delta  # Increment the timer by the frame time

	if throw_type == THROW_TYPE.STRAIGHT:
		# Straight motion with the initial burst speed (constant speed)
		linear_velocity = velocity_initial_burst + (direction * SPEED)
	elif throw_type == THROW_TYPE.ARC:
		# Arc-based motion with initial burst speed
		linear_velocity.x = velocity_initial_burst.x  # Horizontal velocity remains constant

		# Apply air resistance to the x velocity
		linear_velocity.x -= linear_velocity.x * AIR_RESISTANCE * delta

		# Only modify velocity.y after the gravity delay has passed
		if gravity_timer >= GRAVITY_DELAY:
			linear_velocity.y += GRAVITY * delta  # Apply gravity to the vertical velocity
		else:
			linear_velocity.y = velocity_initial_burst.y  # Initial vertical velocity is applied before gravity kicks in
