tool
extends OutputInteractable
class_name Lever


func set_active(value)-> void:
	.set_active(value)
	if value:
		set_sprite_frame(1)
	else:
		set_sprite_frame(0)



