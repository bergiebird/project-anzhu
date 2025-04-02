extends Node2D #Tracks.gd

const FILE_PATH :String = "res://resources/anzhuCharacters/snowTracker/"
const TRACK_PATH :String = "_move.tres"
const ATLAS_OFFSET :Vector2i = Vector2i(1,1)
@onready var L :Libraryton = Libraryton
var all_track_maps :Dictionary[String,TileMapLayer] = {}

func _ready() -> void:
	assert(FILE_PATH, "FILE_PATH not properly instantiated in Tracks.gd")
	assert(TRACK_PATH, "TRACK_PATH not properly instantiated in Tracks.gd")
	assert(ATLAS_OFFSET, "ATLAS_OFFSET not properly instantiated in Tracks.gd")
	assert(L, "LIBRARYTON not properly instantiated in Tracks.gd")

func create_track_map(who :String)->void:
	var new_tile_map = TileMapLayer.new()
	new_tile_map.tile_set  = load(FILE_PATH + L.remove_digits_from_string(who).to_lower() + TRACK_PATH)
	all_track_maps[who] = new_tile_map
	add_child(new_tile_map)

func set_the_track_cell(who :String, where_at :Vector2i, from_to :Vector2i, is_slide :bool, alternative :int)->void:
	all_track_maps[who].set_cell(where_at, int(is_slide), from_to + ATLAS_OFFSET, alternative)




#@onready var tracktype :Dictionary[String,Node]
#func _ready()->void:
	#for child in get_children():
		#tracktype[child.name] = child
	#Libraryton.set_tracks(tracktype)
