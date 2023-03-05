tool
class_name LockedDoor
extends Door

onready var lockSprite: Sprite = $Lock


func _ready() -> void:
	._ready()
	lockSprite = $Lock
	$AnimationPlayer.playback_speed = 10.0


func set_color_mode(color: int)-> void:
	.set_color_mode(color)
	get_node("Lock").modulate = COLORS[color_mode]


# Override, called by output_interactables
func receive_active(value)-> void:
	pass


func unlock_door(value: bool)-> void:
	var collisionTileMap: TileMap = get_collisionTileMap()
	for tile_pos in door_tiles:
		if value:
			collisionTileMap.remove_collision_tile(tile_pos)
		else:
			collisionTileMap.add_collision_tile(tile_pos)
	play_lock_animation()


func play_lock_animation()-> void:
	$AnimationPlayer.play("unlock")
 

func get_collisionTileMap()-> TileMap:
	return get_tree().get_nodes_in_group("collisionMap").front()
