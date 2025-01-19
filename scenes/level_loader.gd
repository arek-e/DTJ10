class_name LevelLoader
extends Node

@export var demo_level_path: String = "res://scenes/level/demo.tscn"
@export var main_level_path: String = "res://scenes/level/level.tscn"
@export var player_scene_path: String = "res://scenes/player/player.tscn"

var player: Node = null  # Reference to the player instance

var current_level: Node = null
var current_level_path: String = ""  # Track the path of the currently loaded level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(demo_level_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func load_level(level_path: String) -> void:
	if current_level:
		current_level.queue_free()
	
	var new_level_scene = load(level_path)
	current_level = new_level_scene.instantiate()
	add_child(current_level)
	
	# Update the current level path
	current_level_path = level_path
	
	add_player_to_level()
	
	if current_level.has_method("on_level_completed"):
		current_level.connect("level_completed", Callable(self, "_on_level_completed"))

func add_player_to_level() -> void:
	if not player:
		var player_scene = load(player_scene_path)
		player = player_scene.instantiate()
		add_child(player)
		
	var start_position = current_level.get_node_or_null("StartPosition")
	if start_position:
		player.global_position = start_position.global_position
	else:
		print_debug("WARN: No Start Position")
	
	

func _on_level_completed() -> void:
	print_debug("Level completed, yay!")
	if current_level_path == demo_level_path:
		load_level(main_level_path)
	elif current_level_path == main_level_path:
		print_debug("Main level completed, yay!")
