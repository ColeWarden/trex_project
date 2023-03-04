tool
class_name Lever
extends OutputInteractable


var lever_flip: bool = false

# If player collides with this object
func interact_area_entered(area: Area2D) -> void:
	if _is_player(area):
		lever_flip = !lever_flip
		set_active(lever_flip)

# Override
func interact_area_exited(area: Area2D) -> void:
	pass

func set_active(value)-> void:
	.set_active(value)
	if value:
		set_sprite_frame(1)
	else:
		set_sprite_frame(0)



