tool
class_name FloorButton
extends OutputInteractable

func set_active(value)-> void:
	.set_active(value)
	if value:
		set_sprite_frame(1)
	else:
		set_sprite_frame(0)

func interact_area_entered(area: Area2D) -> void:
	if _is_player(area):
		set_active(true)

func interact_area_exited(area: Area2D) -> void:
	if _is_player(area):
		set_active(false)
