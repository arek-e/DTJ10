extends Area2D


# Handles the body entering the Area2D.
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):  # Check if the body belongs to the Player group
		_game_over()  # Trigger the game-over logic
	else:
		body.queue_free()  # Remove any other body

# Changes the scene to the game-over screen.
func _game_over() -> void:
	print("Game Over!")
	get_tree().change_scene_to_file("res://scenes/player/game_over_screen.tscn")
