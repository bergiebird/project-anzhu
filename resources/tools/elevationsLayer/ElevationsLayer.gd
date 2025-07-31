
class_name ElevationsLayer
extends TileMapLayer


const ELEVATIONS_ID: int = 0
const CANT_JUMP_HERE: int = 0

@onready var player: Player = get_tree().get_first_node_in_group("player")


func get_players_local_coords()->Vector2i:
	return local_to_map(to_local(player.global_position))


func get_players_current_elevation(current_cords: Vector2i = get_players_local_coords()) -> int:
	return get_cell_tile_data(current_cords).get_custom_data_by_layer_id(ELEVATIONS_ID)


func get_landing_tile(_starting_coords: Vector2i, _direction: Vector2i) -> Array:
	return [
		get_cell_tile_data(_starting_coords + _direction).get_custom_data_by_layer_id(ELEVATIONS_ID), # Landing Elevation
		to_global(map_to_local(_starting_coords + _direction))]                                       # Landing Coords


func evaluate_jump_request(jump_dist: float, direction: int)->Vector2i:
	var starting_coords: Vector2i = get_players_local_coords()
	var starting_elev: int = get_players_current_elevation(starting_coords)
	var jump_vector: Vector2i = Directon.jump_distance_calculation(int(jump_dist), direction)
	var landing_tile: Array = get_landing_tile(starting_coords, jump_vector)
	if starting_elev == CANT_JUMP_HERE or landing_tile[0] == CANT_JUMP_HERE: ## E-Stop tile. Should always come first.
		return Vector2i.ZERO
	elif starting_elev >= landing_tile[0]:
		return landing_tile[1]
	else:
		return Vector2i.ZERO
