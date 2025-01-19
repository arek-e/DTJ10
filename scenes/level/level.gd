extends Node2D

@export var mob_scene: PackedScene

@onready var player := $Level/Player
@onready var camera := $Level/Player/Camera
@onready var mob_spawn_location = $MobPath/MobSpawnLocation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI /2
	
	mob.position = mob_spawn_location.position
	
	add_child(mob)
