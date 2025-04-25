@icon("res://resources/anzhuBeing/snowTracker/icon_grid.png")
class_name SnowTracker extends Node #SnowTracker.gd
enum AltRotation {HORIZONTAL, VERTICAL}
const MAX_SIZE :int = 3
const ATLAS_OFFSET :Vector2i = Vector2i(1,1)
var map_sliding :TileMapLayer
var map_moving :TileMapLayer
var current_cells :Array[Vector2i] = []
var current_map :TileMapLayer
var can_make_tracks :bool = false
@onready var parent :AnzhuBeing = get_parent()

func _ready() -> void:
	if parent.has_node('Abilities'):
		parent.get_node('Abilities').jumping.connect(track_enabler)
	parent.on_new_track_tile.connect(update_tracks)
	parent.sliding.connect(sliding_enabler)
	Libraryton.tracks_reference.connect(setup_maps)

func update_tracks(incoming_cell :Vector2i)->void:
	if can_make_tracks:
		while current_cells.size() <= MAX_SIZE:
			current_cells.push_front(incoming_cell)
		while current_cells.size() > MAX_SIZE:
			current_cells.pop_back()
		var cell_new :Vector2i = current_cells[0]
		var cell_current :Vector2i = current_cells[1]
		var cell_previous :Vector2i = current_cells[2]
		var from_to :Vector2i = (cell_new - cell_current) + (cell_previous - cell_current)
		var alternative :int = determine_alternative(from_to, cell_new.x - cell_current.x)
		from_to += ATLAS_OFFSET
		current_map.set_cell(cell_current, 0, from_to, alternative)

func determine_alternative(from_to :Vector2i, cell_new_x :int)->int:
	var alternative :int = AltRotation.HORIZONTAL
	if from_to == Vector2i.ZERO:
		if cell_new_x == 0:
			alternative = AltRotation.VERTICAL
	return alternative

func setup_maps(ref)->void:
	var personal_maps :Array[TileMapLayer] = Builderton.create_trackMap_array(parent.name)
	map_moving = personal_maps[0]
	parent.personal_track_map = map_moving
	current_map = map_moving
	map_sliding = personal_maps[1]
	can_make_tracks = true
	Libraryton.tracks_reference.disconnect(setup_maps)

func track_enabler(is_jumping :bool)->void:
	can_make_tracks = !is_jumping

func sliding_enabler(is_sliding :bool)->void:
	if is_sliding:
		current_map = map_sliding
	else:
		current_map = map_moving
