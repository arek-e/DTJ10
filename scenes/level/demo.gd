extends Node2D

signal level_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_level_completed() -> void:
	emit_signal("level_completed")


func _on_exit_area_body_entered(body: Node2D) -> void:
	print_debug("ENTERED!: " + body.name)
	if body.name == "Player":
		print_debug("is player")
		on_level_completed()
