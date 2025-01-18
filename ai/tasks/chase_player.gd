@tool
extends BTAction

## Shows or hides a node and returns SUCCESS.
## Returns FAILURE if the node is not found.

# Task parameters.
@export var node_path: NodePath
@export var visible := true


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "SetVisible  %s  node_path: \"%s\"" % [visible, node_path]


# Called each time this task is ticked (aka executed).
func _tick(p_delta: float) -> Status:
	var n: CanvasItem = scene_root.get_node_or_null(node_path)
	if is_instance_valid(n):
		n.visible = visible
		return SUCCESS
	return FAILURE
