tool
class_name LockedDoor
extends Door

onready var lockSprite: Sprite = $Lock


func init() -> void:
	.init()
	lockSprite = $Lock
	receive_active(false)
	$AnimationPlayer.playback_speed = 10.0


func set_color_mode(color: int)-> void:
	.set_color_mode(color)
	get_node("Lock").modulate = COLORS[color_mode]


func unlock_door(value: bool)-> void:
	receive_active(value)
	play_lock_animation()


func play_lock_animation()-> void:
	$AnimationPlayer.play("unlock")
 

func get_collisionTileMap()-> TileMap:
	return get_tree().get_nodes_in_group("collisionMap").front()
