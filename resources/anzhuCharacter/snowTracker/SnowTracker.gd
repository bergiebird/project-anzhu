@icon("res://warehouse/icons/node/icon_grid.png")
class_name SnowTracker extends Node #SnowTracker.gd

const TRACKS :String = "Tracks"
const func_SET_THE_TRACKS_CELL = "set_the_tracks_cell"
@onready var parent :AnzhuCharacter = get_parent()
var moving_layer :TileMapLayer
var sliding_layer :TileMapLayer
var current_layer :TileMapLayer
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		set_process(true)

const TRACK_TILES :Dictionary[String, Vector2i] = {
	"UP_DOWN":Vector2i(0,1),
	"DOWN_UP":Vector2i(0,1),

	"RIGHT_UP":Vector2i(0,2),
	"UP_RIGHT":Vector2i(0,2),

	"RIGHT_DOWN":Vector2i(0,0),
	"DOWN_RIGHT":Vector2i(0,0),

	"LEFT_RIGHT":Vector2i(1,0),
	"RIGHT_LEFT":Vector2i(1,0),

	"LEFT_DOWN":Vector2i(2,0),
	"DOWN_LEFT":Vector2i(2,0),

	"LEFT_UP":Vector2i(2,2),
	"UP_LEFT":Vector2i(2,2),

	"LEFT_LEFT": Vector2i(1,1),
	"RIGHT_RIGHT": Vector2i(1,1),
	"UP_UP": Vector2i(1,1),
	"DOWN_DOWN": Vector2i(1,1),
	"_":Vector2i(1,1)
}

@export var has_sliding_layer = false
var is_sliding :bool = false
var previous_tile_pos :Vector2i = Vector2i(-1, -1)
var current_direction :String = "RIGHT"
var previous_direction :String = "RIGHT"
var is_running :bool = false
var can_make_tracks :bool = true
var velocity :Vector2
var current_tile_position :Vector2i
var current_cells :Array[Vector2i]

func _ready() -> void:
	parent.was_struck.connect(set_is_sliding)
	parent.hit_over.connect(set_is_not_sliding)

func update_tracks(incoming_cell :Vector2i, delta:float)->void:
	while current_cells.size() < 4:
		current_cells.push_front(incoming_cell)
	current_cells.pop_back()
	var from_to :Vector2i = current_cells[0] + current_cells[2]
	var where :Vector2i = current_cells[1]
	var who :String = parent.name
	#parent.communicate_to(TRACKS, func_SET_THE_TRACKS_CELL)


func _update_tracks(delta :float)->void:
	velocity = parent.velocity
	if velocity.length() < 0: return # If no movement, don't do anything
	current_tile_position = current_layer.local_to_map(parent.global_position)
	if parent.name == "Player": current_tile_position.y = current_tile_position.y + 1 #Player only adjustment, could be human only.
	if current_tile_position == previous_tile_pos: return #If the tile is still the same,
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0: current_direction = "RIGHT"
		else:              current_direction = "LEFT"
	else:
		if velocity.y > 0: current_direction = "UP"
		else:              current_direction = "DOWN"
	if previous_tile_pos != Vector2i(-1, -1):
		printt('gotten',get_track_type(previous_direction, current_direction))
		current_layer.set_cell(previous_tile_pos, 0, TRACK_TILES[get_track_type(previous_direction, current_direction)])
	previous_tile_pos = current_tile_position
	previous_direction = current_direction

func get_track_type(from: String, to: String) -> String:
	var from_to: String = from + "_" + to
	if TRACK_TILES.has(from_to):
		return from_to
	if from == to or (from == "LEFT" and to == "RIGHT") or (from == "RIGHT" and to == "LEFT"):
		if from == "LEFT" or from == "RIGHT":
			return "LEFT_RIGHT"
		else:
			return "UP_DOWN"
	return "_"

func set_is_sliding()->void:
	is_sliding = true

func set_is_not_sliding()->void:
	is_sliding = false


func get_current_cell()->void:
	pass
func put_current_cell_in_array()->void:
	pass
func compute_previous_and_entereing()->void:
	pass
func tell_manager_to_set_tile()->void:
	pass
