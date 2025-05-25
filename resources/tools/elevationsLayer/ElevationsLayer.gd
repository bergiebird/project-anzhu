extends TileMapLayer
class_name ElevationsLayer

const CANT_JUMP_HERE: int = 0

var player:Player

func _ready() -> void:
	Libraryton.reference_emitter_deferred("elevation_reference", self, debug)
	Libraryton.player_reference.connect(collect_player_reference)


func evaluate_jump_request(jump_dist: float, direction:int) -> Vector2i:
	var starting_coords:Vector2i = local_to_map(to_local(player.global_position))
	var starting_elev:int = get_cell_tile_data(starting_coords).get_custom_data_by_layer_id(0)
	var jump_dir:Vector2i = Directon.jump_distance_calculation(int(jump_dist), direction)
	var landing_elev:int = get_cell_tile_data(starting_coords + jump_dir).get_custom_data_by_layer_id(0)
	var landing_coords:Vector2 = to_global(map_to_local(starting_coords + jump_dir))
	if starting_elev == CANT_JUMP_HERE or landing_elev == CANT_JUMP_HERE:
		return Vector2i.ZERO
	elif starting_elev >= landing_elev:
		return landing_coords
	else:
		return Vector2i.ZERO


func collect_player_reference(ref:Player):
	player = ref
	Libraryton.player_reference.disconnect(collect_player_reference)

#region	DEBUG
@export var debug:bool = false
#endregion


# Guide to Elevations:
## -1 = Last elevation to jump down to, only use this in emergency situations
## 1 = Sea level, beaches
## 2 = One cliff side up
## 9 = Tallest peak
## 10 = EMERGENCY situations
## RED = Never Jump to or from here
