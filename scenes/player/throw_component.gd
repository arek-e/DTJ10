extends Node2D
class_name ThrowComponent

@export var projectile: PackedScene = preload("res://scenes/player/projectile.tscn")
@onready var spawnMarker: Marker2D = $SpawnMarker

func throw():
	if not projectile or not spawnMarker:
		push_error("Projectile or SpawnMarker is not set.")
		return

	var instance = projectile.instantiate()
	var mouse_position = get_global_mouse_position()
	var spawn_position = spawnMarker.global_position
	var direction = (mouse_position - spawn_position).normalized()

	# Initialize the projectile based on its throw type
	if instance.has_method("initialize"):
		instance.initialize(spawn_position, direction)

	# Add the projectile to the root (or parent node)
	get_tree().root.add_child(instance)
