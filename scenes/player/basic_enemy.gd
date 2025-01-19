extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const jump_power = -400
const gravity = 50 

var last_dir
func _physics_process(delta: float) -> void:
	# Handle jumping logic
	if is_on_wall() and is_on_floor():
		velocity.y = jump_power
	else:
		velocity.y += gravity
	move_and_slide()

# Function to move the character and handle animations
func move(dir, speed) -> void:
	velocity.x = dir * speed
	last_dir = dir
	handle_animation(dir)

# Function to handle animation based on the character's direction
func handle_animation(dir) -> void:
	if dir == 0 or velocity.x == 0:
		animation_player.play("idle")
	else:
		if dir > 0:
			animation_player.play("run_right")
		else:
			animation_player.play("run_left")

# Function to play attack animation based on the last direction
func play_attack() -> void:
	if last_dir > 0:
		animation_player.play("attack_right")
	else:
		animation_player.play("attack_left")
