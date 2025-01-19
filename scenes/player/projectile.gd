extends RigidBody2D

enum THROW_TYPE { STRAIGHT, ARC }

@export var throw_type: THROW_TYPE = THROW_TYPE.STRAIGHT
@export var SPEED: float = 100  # Constant speed for all directions
@export var GRAVITY: float = 300.0  # Gravity value for ARC mode
@export var INITIAL_BURST_SPEED: float = 300.0  # Initial burst of speed for momentum
@export var GRAVITY_DELAY: float = 0.1  # Time in seconds before gravity starts affecting the projectile
@export var AIR_RESISTANCE: float = 0.05  # Air resistance factor affecting x velocity (0-1, where 1 is high resistance)
@export var SLOW_VELOCITY_THRESHOLD: float = 10.0  # Velocity threshold for considering "slow"
@export var SLOW_VELOCITY_TIME: float = 3.0  # Time before despawn if velocity is too slow
@export var X_VELOCITY_THRESHOLD: float = 40.0  # Horizontal velocity threshold for stopping the projectile
@export var STOP_VELOCITY_TIME: float = 2.0  # Time before despawn if X velocity is slow and grounded

var direction: Vector2 = Vector2.ZERO
var initial_velocity: Vector2 = Vector2.ZERO
var velocity_initial_burst: Vector2 = Vector2.ZERO
var gravity_timer: float = 0.0  # Timer to track when gravity should start applying
var slow_velocity_timer: float = 0.0  # Timer to track how long the velocity has been slow
var stop_velocity_timer: float = 0.0  # Timer to track how long the velocity has been slow and grounded

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
		animated_sprite.play("default")
		
	linear_velocity = velocity_initial_burst	

func _physics_process(delta: float) -> void:
	# Increment gravity timer
	gravity_timer += delta

	# Apply motion logic based on throw type
	if throw_type == THROW_TYPE.STRAIGHT:
		# Only adjust linear velocity without reapplying initial burst
		linear_velocity += direction * SPEED * delta
	elif throw_type == THROW_TYPE.ARC:
		# Apply air resistance to horizontal velocity
		linear_velocity.x -= linear_velocity.x * AIR_RESISTANCE * delta

		# Apply gravity to vertical velocity after delay
		if gravity_timer >= GRAVITY_DELAY:
			linear_velocity.y += GRAVITY * delta

	# Handle collisions and apply friction
	var is_on_ground = false  # Track if the projectile is on the ground
	for node in get_colliding_bodies():
		if node.is_in_group("Ground"):
			# Get collision normal
			var collision_normal = (global_position - node.global_position).normalized()
			is_on_ground = abs(collision_normal.y) > 0.8  # Close to vertical

			# Decompose velocity into normal and tangential components
			var normal_velocity = linear_velocity.dot(collision_normal) * collision_normal
			var tangential_velocity = linear_velocity - normal_velocity

			# Apply stronger friction when rolling on the ground
			if is_on_ground:
				var ground_friction_coefficient = 2300.0  # Adjust to desired friction
				tangential_velocity -= tangential_velocity.normalized() * ground_friction_coefficient * delta

			# Clamp tangential velocity to stop rolling
			if tangential_velocity.length() < 10.0:  # Threshold for stopping
				tangential_velocity = Vector2.ZERO

			# Combine the adjusted velocities
			linear_velocity = normal_velocity + tangential_velocity
			
		# Check if the X velocity is below the threshold
			if abs(linear_velocity.x) < X_VELOCITY_THRESHOLD:
				# If the X velocity is slow and grounded, start the timer for stopping
				stop_velocity_timer += delta

				# Stop the velocity completely if it is slow enough and on the ground
				linear_velocity.x = 0
				linear_velocity.y = 0

				# Pause the animation if the velocity is slow
				if animated_sprite and !animated_sprite.is_playing():
					animated_sprite.play("idle")  # Play idle animation (or any other default animation)
				else:
					animated_sprite.stop()  # Pause animation

				# If the velocity has been slow for the specified time, despawn the projectile
				if stop_velocity_timer >= STOP_VELOCITY_TIME:
					queue_free()  # Remove the projectile from the scene
			else:
				# Reset the stop velocity timer if the conditions are no longer met
				stop_velocity_timer = 0.0
				slow_velocity_timer = 0.0
			
			print_debug(linear_velocity.x)
