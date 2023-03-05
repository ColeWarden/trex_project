tool
class_name Key
extends OutputInteractable

enum MODE {
	IDLE,
	PLAYER,
	DOOR,
	FINISH,
}

const MIN_DIST: float = 4.0

var mode: int = MODE.IDLE

onready var target: Node2D = null

func _ready() -> void:
	$AnimationPlayer.playback_speed = 10.0
	$AnimationPlayer.play("idle")

# If player collides with this object
func interact_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if mode == MODE.IDLE:
			if _is_player(area):
				set_player(area.get_parent())


func set_player(player: Node2D):
	target = player
	mode = MODE.PLAYER


func set_door(door: Node2D):
	target = door
	mode = MODE.DOOR
	$AnimationPlayer.play("door_unlock")


func _process(delta: float) -> void:
	if mode == MODE.IDLE:
		return
	
	var target_pos: Vector2 = target.global_position
	var key_offset = Vector2(0,0)
	if mode == MODE.PLAYER:
		key_offset = Vector2(0, -48)
	elif mode == MODE.DOOR:
		key_offset = Vector2(0,0)
		if target_pos.distance_to(global_position) <= MIN_DIST:
			$AnimationPlayer.play("key_click")
			mode = MODE.FINISH
	var weight: float = 5.0
	
	global_position = global_position.linear_interpolate(target_pos + key_offset, delta * weight)


# If player leaves this object collision
func interact_area_exited(_area: Area2D) -> void:
	pass


func _unlock_door()-> void:
	target.unlock_door(true)


func set_color_mode(color: int)-> void:
	.set_color_mode(color)
	$Particles2D.process_material.color = COLORS[color]


func _on_InteractArea_area_entered(area: Area2D) -> void:
	if mode == MODE.PLAYER:
		var _target: Node2D = area.get_parent()
		if _target is LockedDoor:
			if _target.input_key == output_key:
				set_door(_target)
