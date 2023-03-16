tool
class_name FloorButton
extends OutputInteractable

var active_count = 0
func _ready() -> void:
	active_count = 0;

func set_active(value)-> void:
	.set_active(value)
	if value:
		
		set_sprite_frame(1)
	elif active_count <= 0:
			set_sprite_frame(0)

func interact_area_entered(area: Area2D) -> void:
	if _is_player(area):
		active_count += 1;
		set_active(true)

func interact_area_exited(area: Area2D) -> void:
	if _is_player(area):
		active_count -= 1;
		set_active(false)
