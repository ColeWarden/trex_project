tool
class_name Door
extends InputInteractable



export(PoolVector2Array) var door_tiles: PoolVector2Array = []
var active_count = 0

func _ready():
	var collisionTileMap: TileMap = get_collisionTileMap()
	active_count = 0
	for tile_pos in door_tiles:
		collisionTileMap.add_collision_tile(tile_pos)

# Override, called by output_interactables
func receive_active(value)-> void:
	var collisionTileMap: TileMap = get_collisionTileMap()
	if (value):
		active_count += 1
	else:
		active_count -= 1
	for tile_pos in door_tiles:
		#print("Active count: ", active_count)
		if value and active_count > 0:
			collisionTileMap.remove_collision_tile(tile_pos)
			set_sprite_mod_a(0.3)
		elif active_count <= 0:
			collisionTileMap.add_collision_tile(tile_pos)
			set_sprite_mod_a(1.0)


func get_collisionTileMap()-> TileMap:
	return get_tree().get_nodes_in_group("collisionMap").front()
