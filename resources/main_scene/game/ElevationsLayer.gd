extends TileMapLayer #ElevationsLayer.gd

var player :Player


func _ready() -> void:
	Libraryton.reference_emitter_deferred("elevation_reference", self)
	Libraryton.player_reference.connect(func(ref): player = ref)

func evaluate_jump_request(jump_dist :float)->Vector2i:
	var starting_coords :Vector2i = local_to_map(to_local(player.global_position))
	var starting_elev :int = get_cell_tile_data(starting_coords).get_custom_data_by_layer_id(0)
	var jump_dir :Vector2i = Directon.jump_distance_calculation(jump_dist)
	var landing_elev :int = get_cell_tile_data(starting_coords + jump_dir).get_custom_data_by_layer_id(0)
	var landing_coords :Vector2 = to_global(map_to_local(starting_coords + jump_dir))

	if starting_elev >= landing_elev:
		return landing_coords
	else:
		return Vector2i.ZERO
