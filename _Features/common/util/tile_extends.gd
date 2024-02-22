class_name TileExtends


static func get_random_cell_world(node: Node2D, tilemap: TileMap, layer: int) -> Vector2:
	var rand_cell: Vector2i = RandExtends.rand_array(tilemap.get_used_cells(layer))
	return node.to_global(tilemap.map_to_local(rand_cell))


static func convert_next_path_position_into_velocity(
	node: Node2D, nav_agent: NavigationAgent2D
) -> Vector2:
	return (
		node.to_local(nav_agent.get_next_path_position()).normalized()
		if !nav_agent.is_navigation_finished()
		else Vector2.ZERO
	)


static func tile_to_global(tilemap: TileMap, tile_coords: Vector2i) -> Vector2:
	var local_coords := tilemap.map_to_local(tile_coords)
	var global_coords := tilemap.to_global(local_coords)

	return global_coords
