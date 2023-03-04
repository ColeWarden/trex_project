tool
class_name OutputInteractable
extends Interactable

"""
Output interactable sends key to Input interactable; is used for levers, buttons, etc...
"""

export(String) var output_key: String

onready var interactableArea: Area2D = $InteractableArea

func _ready() -> void:
	._ready()
	var _err = interactableArea.connect("area_entered", self, "interact_area_entered")
	_err = interactableArea.connect("area_exited", self, "interact_area_entered")
	yield(get_tree(), "idle_frame")
	update()

# Override, called by interact Area (aka player)
# (Player flips lever)
func set_active(_value)-> void:
	call_active(_value)


# Calls input interacle's receive_active
# (Lever activates input interactable's recieve_active)
func call_active(value)-> void:
	var inputs: Array = get_input_interactables(output_key)
	for input in inputs:
		input.receive_active(value)


# Returns array of interactable with input_key == this node's output_key
func get_input_interactables(group_name: String)-> Array:
	return get_tree().get_nodes_in_group(group_name)


# Takes in an area node (preferably a interact.tscn node)
func _is_player(area: Area2D)-> bool:
	return area.get_parent() is Player


# If player collides with this object
func interact_area_entered(area: Area2D) -> void:
	if _is_player(area):
		set_active(true)


# If player leaves this object collision
func interact_area_exited(area: Area2D) -> void:
	if _is_player(area):
		set_active(false)


func _draw():
	if Engine.editor_hint:
		var inputs: Array = get_input_interactables(output_key)
		for input in inputs:
			var local_pos: Vector2 = input.global_position - global_position
			var local_mid_pos: Vector2 = local_pos / 2.0
			var lines = PoolVector2Array([local_pos, local_mid_pos])
			var colors = PoolColorArray([Color.red, Color.green])
			var width: float = 2.0
			draw_line(Vector2.ZERO, local_mid_pos, Color.red, width)
			draw_line(local_mid_pos, local_pos, Color.green, width)
			
			#draw_line(Vector2.ZERO, local_pos, Color.black, 1.3)
			#draw_circle(local_pos, 3.0, Color.black)
