extends CharacterBody2D

@onready var anim_tree: AnimationTree = $AnimationTree

const jump_power = -400
const gravity = 50 


func _physics_process(delta: float) -> void:
	if is_on_wall() and is_on_floor():
		velocity.y = jump_power

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

# Function to move the character and handle animations
func move(dir, speed):

	velocity.x = dir * speed
	handle_animation(dir)  # Pass the direction to handle animation
	
# Function to handle animation based on the character's direction
func handle_animation(dir: int):
	anim_tree["parameters/StateMachine/conditions/is_attacking"] = false
	if velocity == Vector2.ZERO:
		anim_tree["parameters/StateMachine/Run/blend_position"] = 0
	else:
		if dir > 0:
			anim_tree["parameters/StateMachine/Run/blend_position"] = 1
		else:
			anim_tree["parameters/StateMachine/Run/blend_position"] = -1


func check_for_self(node):
	if node == self:
		return true
	else:
		false

# Function to play attack animation based on last direction
func play_attack(dir: float) -> void:
	anim_tree["parameters/StateMachine/conditions/is_attacking"] = true
