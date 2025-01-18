extends Node2D
class_name HealthComponent

@export var MAX_HEALTH:= 10.0
var current_health: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = MAX_HEALTH


func take_damage(damage: float):
	current_health -= damage
	
	if current_health <= 0:
		get_parent().queue_free()
