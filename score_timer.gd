extends Timer

# This function will be called every second
func _on_Timer_timeout():
	# Get the TimeLabel node
	var label = get_node("../TimeLabel")
	# Calculate the elapsed time
	var elapsed_time = get_time()
	# Update the label text with the elapsed time
	label.text = str(elapsed_time)

# This function calculates the elapsed time since the timer started
func get_time():
	var elapsed_seconds = OS.get_ticks_msec() / 1000 - start_time
	return elapsed_seconds

# Store the start time when the timer starts
var start_time = 0

func _ready():
	# Start the timer
	start()
	start_time = OS.get_ticks_msec() / 1000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	pass # Replace with function body.
