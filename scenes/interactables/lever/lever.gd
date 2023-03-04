tool
class_name Lever
extends OutputInteractable


func set_active(value)-> void:
	.set_active(value)
	print(value)
	if value:
		set_sprite_frame(1)
	else:
		set_sprite_frame(0)



