extends TileMapLayer
class_name ElevationsLayer

const CANT_JUMP_HERE: int = 0

func _ready():
	Signalton.reference_emitter_deferred("elevation_reference", self, debug)
	Signalton.player_reference.connect(collect_player_reference)

## Already possesses player's reference, will return the local coords
## if all tilemaps have the same origin, this could be promoted
func get_players_local_coords()->Vector2i:
	return local_to_map(to_local(player.global_position))


## Useful for knowing what elevation the player is currently on
## Jumping, Fog are the current reasons for this.
func get_players_current_elevation(_current_cords :Vector2i = get_players_local_coords())->int:
	return get_cell_tile_data(_current_cords).get_custom_data_by_layer_id(0)

## Creates a dynamic Array because of the double usage of starting_coords and direction.
func get_landing_tile(_starting_coords, _direction)->Array:
	var landing_elevation :int = get_cell_tile_data(_starting_coords + _direction).get_custom_data_by_layer_id(0)
	var landing_coords :Vector2 = to_global(map_to_local(_starting_coords + _direction))
	return [landing_elevation, landing_coords]


## Breaking this down as parts of this algorithm is useful for fog while the majority of it
## is only useful for jumping.
func evaluate_jump_request(jump_dist: float, direction:int)->Vector2i:
	# Collection
	var starting_coords :Vector2i = get_players_local_coords()
	var starting_elev :int = get_players_current_elevation(starting_coords)
	var jump_vector :Vector2i = Directon.jump_distance_calculation(int(jump_dist), direction)
	var landing_tile :Array = get_landing_tile(starting_coords, jump_vector)
	# Evaluation
	if starting_elev == CANT_JUMP_HERE or landing_tile[0] == CANT_JUMP_HERE: return Vector2i.ZERO
	elif starting_elev >= landing_tile[0]:                                   return landing_tile[1]
	else:                                                                    return Vector2i.ZERO













#region    #=====================================================# DEBUG
@export var debug:bool = false

var player :Player
func collect_player_reference(ref:Player):
	player = ref
	Signalton.player_reference.disconnect(collect_player_reference)
#endregion
