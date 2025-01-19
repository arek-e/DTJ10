class_name Game
extends Node

@export var mob_scene: PackedScene

@onready var player := $Level/Player
@onready var camera := $Level/Player/Camera
@onready var mob_spawn_location = $MobPath/MobSpawnLocation
@onready var label := $CanvasLayer/TimeLabel
@onready var score_timer := $ScoreTimer

var current_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game() -> void: 
	$StartTimer.start()
	

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI /2

	mob.position = mob_spawn_location.position
	
	
	
	add_child(mob)


func _on_score_timer_timeout() -> void:
	current_time += score_timer.get_wait_time()
	
	label.text = str(current_time)
