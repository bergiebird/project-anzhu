extends Node2D #Tracks.gd

const PATH_START :String = "res://resources/anzhuCharacter/snowTracker/"
const PATH_END :String = "_move.tres"
const ATLAS_OFFSET :Vector2i = Vector2i(1,1)
@onready var L :Libraryton = Libraryton

func create_track_map(who :String)->TileMapLayer:
	var new_tile_map = TileMapLayer.new()
	new_tile_map.tile_set  = load(PATH_START + L.remove_digits_from_string(who).to_lower() + PATH_END)
	add_child(new_tile_map)
	return new_tile_map

func set_the_track_cell(which_map:TileMapLayer, where_at:Vector2i, from_to:Vector2i, is_slide:bool, alternative:int)->void:
	which_map.set_cell(where_at, int(is_slide), from_to + ATLAS_OFFSET, alternative)
