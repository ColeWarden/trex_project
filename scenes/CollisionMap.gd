extends TileMap


func add_collision_tile(tile_pos: Vector2):
	set_cellv(tile_pos, 0)


func remove_collision_tile(tile_pos: Vector2):
	set_cellv(tile_pos, -1)


# Vector2(128, 96) -> Vector2(8, 6)
func world_position_to_tile_pos(world_pos: Vector2)-> Vector2:
	return world_to_map(world_pos)


#Vector2(8, 6) ->  Vector2(128, 96)
func tile_position_to_world_pos(tile_pos: Vector2)-> Vector2:
	return map_to_world(tile_pos)


