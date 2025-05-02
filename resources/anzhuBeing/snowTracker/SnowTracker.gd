@icon("res://resources/anzhuBeing/snowTracker/icon_grid.png")
class_name SnowTracker extends Marker2D #SnowTracker.gd

enum AltRotation {HORIZONTAL, VERTICAL}
const ATLAS_OFFSET :Vector2i = Vector2i(1,1)
const MAX_CELL_ARRAY_SIZE :int = 3
var current_cells :Array[Vector2i] = []
var last_known_tile_coords :Vector2i
var personal_maps :Array[TileMapLayer]
var current_map :TileMapLayer
var can_make_tracks :bool = false
@onready var parent :AnzhuBeing = get_parent()

func _ready() -> void:
	Debuggerton.signal_checker([
		parent.sliding.connect(sliding_enabler),
		Libraryton.tracks_reference.connect(setup_maps)
	])

func being_process(_delta :float)->void:
	if can_make_tracks:
		check_current_tile()

func check_current_tile()->void:
	var current_tile_coords :Vector2i = get_track_markers_tile()
	if current_tile_coords != last_known_tile_coords:
		last_known_tile_coords = current_tile_coords
		update_tracks(current_tile_coords)
	elif last_known_tile_coords == null:
		last_known_tile_coords = current_tile_coords

func update_tracks(incoming_cell :Vector2i)->void:
	while current_cells.size() <= MAX_CELL_ARRAY_SIZE:
		current_cells.push_front(incoming_cell)
	while current_cells.size() > MAX_CELL_ARRAY_SIZE:
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

func setup_maps(_ref :CanvasGroup)->void:
	personal_maps = Builderton.create_trackMap_array(parent.name)
	current_map = personal_maps[0]
	can_make_tracks = true
	Libraryton.tracks_reference.disconnect(setup_maps)

func sliding_enabler(is_sliding :bool)->void:
	current_map = personal_maps[int(is_sliding)]

func get_track_markers_tile()->Vector2i:
	return current_map.local_to_map(current_map.to_local(global_position))

func enable_tracks_inverse(is_jumping :bool)->void:
	can_make_tracks = !is_jumping
