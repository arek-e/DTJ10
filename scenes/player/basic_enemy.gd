extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const jump_power = -400
const gravity = 50 

func _physics_process(delta: float) -> void:
	if is_on_wall() and is_on_floor():
		velocity.y = jump_power

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	print(velocity)
	
	move_and_slide()

# Function to move the character and handle animations
func move(dir, speed):
	velocity.x = dir * speed
	handle_animation(dir)  # Pass the direction to handle animation
	
# Function to handle animation based on the character's direction
func handle_animation(dir: int):
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")  # Play idle animation if no movement
	else:
		if dir > 0:
			animated_sprite.play("run_right")  # Play right run animation
		else:
			animated_sprite.play("run_left")  # Play left run animation
