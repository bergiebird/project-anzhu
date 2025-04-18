extends TileMapLayer #ElevationsLayer.gd

var player :Player
signal character_elevation_evaluated(outgoing :Dictionary)


func _ready() -> void:
	Libraryton.reference_emitter_deferred("elevation_reference", self)
	Libraryton.player_reference.connect(func(ref): player = ref)
func evaluate_jump_request(jump_distance :float)->Vector2i:
	var starting_coordinates :Vector2i = local_to_map(to_local(player.global_position))
	var starting_elevation :int = get_cell_tile_data(starting_coordinates).get_custom_data_by_layer_id(0)
	var landing_elevation :int = get_cell_tile_data(starting_coordinates).get_custom_data_by_layer_id(0)
	var jump_direction = Directon.get_player_direction("jump")
	var landing_coordinates :Vector2i = starting_coordinates + jump_direction
	if starting_elevation >= landing_elevation:
		return landing_coordinates
	else:
		return Vector2i.ZERO
