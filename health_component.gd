extends Node2D
class_name HealthComponent

@export var MAX_HEALTH:= 10.0
@onready var damage_pos: Marker2D = $DamageNumberLocation
var current_health: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = MAX_HEALTH


func take_damage(attack: Attack):
	current_health -= attack.attack_damage	
	DamageNumbers.display_number(attack.attack_damage, damage_pos.global_position, attack.is_critical_hit)
	
	if current_health <= 0:
		get_parent().queue_free()
