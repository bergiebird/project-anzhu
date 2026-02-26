
class_name ElevationsLayer
extends TileMapLayer


const ELEVATIONS_ID: int = 0
const CANT_JUMP_HERE: int = 0

@onready var player: Player = get_tree().get_first_node_in_group("player")


func evaluate_jump_request(jump_dist: float, direction: int) -> Vector2i:
	evaluate_jump_request_by_tile(jump_dist, direction)
	var starting_coords: Vector2i = _get_players_local_coords()
	var starting_elev: int = get_players_current_elevation(starting_coords)
	var jump_vector: Vector2i = Directon.jump_distance_calculation(int(jump_dist), direction)
	var landing_tile: Array = _get_landing_tile(starting_coords, jump_vector)
	if starting_elev == CANT_JUMP_HERE or landing_tile[0] == CANT_JUMP_HERE: ## E-Stop tile. Should always come first.
		return Vector2i.ZERO
	elif starting_elev >= landing_tile[0]:
		return landing_tile[1]
	else:
		return Vector2i.ZERO


func _get_players_local_coords() -> Vector2i:
	return local_to_map(to_local(player.global_position))


func _get_landing_tile(_starting_coords: Vector2i, _direction: Vector2i) -> Array:
	return [
		get_cell_tile_data(_starting_coords + _direction).get_custom_data_by_layer_id(ELEVATIONS_ID), # Landing Elevation
		to_global(map_to_local(_starting_coords + _direction))]                                       # Landing Coords


func get_players_current_elevation(current_cords: Vector2i = _get_players_local_coords()) -> int:
	return get_cell_tile_data(current_cords).get_custom_data_by_layer_id(ELEVATIONS_ID)


func evaluate_jump_request_by_tile(jump_dist: float, direction: int) -> Array:
	var starting_coords: Vector2i = _get_players_local_coords()
	var jump_vector: Vector2i = Directon.jump_distance_calculation(int(jump_dist), direction)
	var step_count: int = maxi(abs(jump_vector.x), abs(jump_vector.y))  # How many tiles to walk through
	var tiles: Array = []                                      # Ordered from player outward to landing
	for i: int in range(1, step_count + 1):
		var tile_coords: Vector2i = starting_coords + Vector2i(sign(jump_vector.x) * i, sign(jump_vector.y) * i)
		var tile_data: TileData = get_cell_tile_data(tile_coords)
		tiles.append({
			"coords":     tile_coords,
			"global_pos": to_global(map_to_local(tile_coords)),
			"elevation":  tile_data.get_custom_data_by_layer_id(ELEVATIONS_ID) if tile_data else CANT_JUMP_HERE
		})
	for i in tiles:
		print(i)
	return tiles                                               # Each dict has coords, global_pos, and elevation
