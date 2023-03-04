tool
class_name Target
extends OutputInteractable

export(bool) var oneshot: bool = false

# Only used if oneshot is true
var oneshot_hit: bool = false

func _ready() -> void:
	var _err = $HitArea.connect("area_entered", self, "hit_area_entered")
	_err = $HitArea.connect("area_exited", self, "hit_area_exited")

# Override, not needed
func interact_area_entered(_area: Area2D) -> void:
	pass


# Override, not needed
func interact_area_exited(_area: Area2D) -> void:
	pass


# Hit hurtArea enters
func hit_area_entered(area: Area2D) -> void:
	if oneshot and !oneshot_hit:
		oneshot_hit = true
		set_active(true)


# If player leaves this object collision
func hit_area_exited(_area: Area2D) -> void:
	if !oneshot:
		set_active(true)


#func _is_hurtArea(_area: Area2D)-> bool:
#	return area.name == "HurtArea"


func set_active(value)-> void:
	.set_active(value)
	if value:
		set_sprite_frame(1)
	else:
		set_sprite_frame(0)


