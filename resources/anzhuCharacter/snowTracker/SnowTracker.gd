@icon("res://warehouse/icons/node/icon_grid.png")
class_name SnowTracker extends Node #SnowTracker.gd
@export_group('DEBUG')
@export var debug_snow_tracker :bool = false
var parent :AnzhuCharacter
var moving_layer :TileMapLayer
var sliding_layer :TileMapLayer
var current_layer :TileMapLayer
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		parent = node_dictionary["scene_root"]
		set_process(true)

const TRACK_TILES :Dictionary[String, Vector2i] = {
	"UP_DOWN":Vector2i(0,1), "DOWN_UP":Vector2i(0,1),
	"RIGHT_UP":Vector2i(0,2), "UP_RIGHT":Vector2i(0,2),
	"RIGHT_DOWN":Vector2i(0,0), "DOWN_RIGHT":Vector2i(0,0),
	"LEFT_RIGHT":Vector2i(1,0), "RIGHT_LEFT":Vector2i(1,0),
	"LEFT_DOWN":Vector2i(2,0), "DOWN_LEFT":Vector2i(2,0),
	"LEFT_UP":Vector2i(2,2), "UP_LEFT":Vector2i(2,2),
	"LEFT_LEFT": Vector2i(1,1), "RIGHT_RIGHT": Vector2i(1,1), "UP_UP": Vector2i(1,1), "DOWN_DOWN": Vector2i(1,1), "_":Vector2i(1,1),}

var previous_tile_pos :Vector2i = Vector2i(-1, -1)
var current_direction :String = "RIGHT"
var previous_direction :String = "RIGHT"
var is_running :bool = false
var can_make_tracks :bool = true

func _ready()->void:
	Libraryton.tracks.connect(track_signal)
	set_process(false)

func track_signal(incoming_dictionary :Dictionary[String,Node])->void:
	moving_layer = incoming_dictionary[parent.name + "_Move"]
	if parent.name == "Bear":
		sliding_layer = incoming_dictionary["Bear_Slide"]
	current_layer = moving_layer

func _process(delta: float)->void:
	if current_layer != null and can_make_tracks: #if there is a reciever and is enabled
		update_tracks(delta)

func update_tracks(delta :float)->void:
	var velocity :Vector2 = parent.velocity
	if velocity.length() < 0:
		return
	var current_tile_pos :Vector2i = current_layer.local_to_map(parent.global_position)
	if parent.name == "Player":
		current_tile_pos.y = current_tile_pos.y + 1
	if current_tile_pos == previous_tile_pos:
		return
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			current_direction = "RIGHT"
		else:
			current_direction = "LEFT"
	else:
		if velocity.y > 0:
			current_direction = "UP"
		else:
			current_direction = "DOWN"
	if previous_tile_pos != Vector2i(-1, -1):
		current_layer.set_cell(previous_tile_pos, 0, TRACK_TILES[get_track_type(previous_direction, current_direction)])
	previous_tile_pos = current_tile_pos
	previous_direction = current_direction

func get_track_type(from :String, to :String)->String:
	var from_to :String = from + "_" + to
	print(from_to)
	if from == to or (from == "LEFT" and to == "RIGHT") or (from == "RIGHT" and to == "LEFT"):
		if from == "LEFT" or from == "RIGHT":
			return "LEFT_RIGHT" #LEFT_LEFT, #LEFT_RIGHT, #RIGHT_LEFT, #RIGHT_RIGHT
		if from == "UP" or from == "DOWN":
			return "UP_DOWN" # UP_DOWN, DOWN_UP, DOWN_DOWN, UP_UP
	if from == "LEFT":
		if to == "UP":
			return "RIGHT_DOWN" #RIGHT_UP, RIGHT_DOWN, DOWN_RIGHT, UP_RIGHT
		else:
			return "RIGHT_UP"
	if from == "RIGHT":
		if to == 'UP':
			return "LEFT_DOWN" #LEFT_UP, LEFT_DOWN, UP_LEFT, DOWN_LEFT
		else:
			return "LEFT_UP"
	if from == "UP":
		if to == 'LEFT':
			return "LEFT_UP"
		else:
			return "RIGHT_UP"
	if from == "DOWN":
		if to == "LEFT":
			return "LEFT_DOWN"
		else:
			return "RIGHT_DOWN"
	return "_"



func set_track_style_to_slide(unused_string :String)->void:
	current_layer = sliding_layer
func set_track_style_to_walk(unused_string :String)->void:
	current_layer = moving_layer

func debug()->void:
	print_rich('[color=eaf1f0]SnowTracker debugging enabled . . .[/color]')
	debug_snow_tracker = true
