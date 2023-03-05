tool
class_name Door
extends InputInteractable



export(PoolVector2Array) var door_tiles: PoolVector2Array = []

# Override, called by output_interactables
func receive_active(value)-> void:
	var collisionTileMap: TileMap = get_collisionTileMap()
	for tile_pos in door_tiles:
		if value:
			collisionTileMap.remove_collision_tile(tile_pos)
			set_sprite_mod_a(0.3)
		else:
			collisionTileMap.add_collision_tile(tile_pos)
			set_sprite_mod_a(1.0)


func get_collisionTileMap()-> TileMap:
	return get_tree().get_nodes_in_group("collisionMap").front()
