extends TileMapLayer #ElevationsLayer.gd

var player :Player
const JUMP_DISTANCE :int = 2


func _ready() -> void:
	Libraryton.reference_emitter_deferred("elevation_reference", self)
	Libraryton.player_reference.connect(func(ref): player = ref)

func evaluate_jump_request(jump_distance :float)->Vector2i:
	var starting_coordinates :Vector2i = local_to_map(to_local(player.global_position))
	var starting_elevation :int = get_cell_tile_data(starting_coordinates).get_custom_data_by_layer_id(0)
	var jump_direction = Directon.jump_distance_calculation(JUMP_DISTANCE)
	var landing_elevation :int = get_cell_tile_data(starting_coordinates + jump_direction).get_custom_data_by_layer_id(0)
	var landing_coordinates = to_global(map_to_local(starting_coordinates + jump_direction))
	if starting_elevation >= landing_elevation: return landing_coordinates
	else:                                       return Vector2i.ZERO
