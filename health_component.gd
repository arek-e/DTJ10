extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 10.0
@onready var damage_pos: Marker2D = $DamageNumberLocation
var current_health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = MAX_HEALTH


func take_damage(attack: Attack):
	current_health -= attack.attack_damage	
	DamageNumbers.display_number(attack.attack_damage, damage_pos.global_position, attack.is_critical_hit)
	
	if current_health <= 0:
		if is_parent_player():
			_game_over()
		else:
			get_parent().queue_free()

func is_parent_player() -> bool:
	# Assuming the player has a specific script or identifier
	return get_parent().is_in_group("Player")

func _game_over() -> void:
	# Replace this with your game-over screen logic
	print("Game Over!")
	get_tree().change_scene_to_file("res://scenes/player/game_over_screen.tscn")
