@icon("res://resources/anzhuBeing/snowTracker/icon_grid.png")
extends Marker2D
class_name SnowTracker

var current_cells :Array[Vector2i] = []
var current_tile_coords :Vector2i
var personal_maps :Array[TileMapLayer]
var current_map :TileMapLayer
var elevation_map :ElevationsLayer
var current_elevation :int
var new_elevation :int
var can_make_tracks :bool = false

#region    #===============================================================# READY
func _ready():
	Signalton.tracks_reference.connect(setup_maps)
	Signalton.elevation_reference.connect(elevation_reference_subscriber)

func elevation_reference_subscriber(elev_ref :TileMapLayer):
	elevation_map = elev_ref
	Signalton.elevation_reference.disconnect(elevation_reference_subscriber)

func setup_maps(_ref :CanvasGroup):
	personal_maps = Builderton.create_trackMap_array(parent.name)
	current_map = personal_maps[0]
	can_make_tracks = true
	Signalton.tracks_reference.disconnect(setup_maps)
#endregion #===============================================================# READY
func _process(_delta: float):
	check_current_tile()

func check_current_tile():
	if can_make_tracks:
		var new_tile_coords :Vector2i = current_map.local_to_map(current_map.to_local(global_position))
		if new_tile_coords!=current_tile_coords or current_tile_coords==null:
			current_tile_coords = new_tile_coords
			on_new_tile(new_tile_coords)

func on_new_tile(incoming_cell :Vector2i):
	if parent is Player:
		_check_elevation()
	_reorder_cells(incoming_cell)
	var cell_new :Vector2i = current_cells[0]
	var cell_current :Vector2i = current_cells[1]
	var cell_previous :Vector2i = current_cells[2]
	var from_to :Vector2i = (cell_new - cell_current) + (cell_previous - cell_current)
	var alternative :int = determine_alternative(from_to, cell_new.x - cell_current.x)
	from_to +=L.Tracking.ATLAS_OFFSET
	current_map.set_cell(cell_current, 0, from_to, alternative)

func _check_elevation():
	new_elevation = elevation_map.get_players_current_elevation()
	if new_elevation!=current_elevation or current_elevation==null:
		parent.publish_event.emit("on_new_elevation", new_elevation)
		current_elevation = new_elevation

func _reorder_cells(_incoming_cell :Vector2i):
	while current_cells.size()<=L.Tracking.MAX_CELL_ARRAY_SIZE:
		current_cells.push_front(_incoming_cell)
	while current_cells.size() >L.Tracking.MAX_CELL_ARRAY_SIZE:
		current_cells.pop_back()

func determine_alternative(from_to :Vector2i, cell_new_x :int)->int:
	var alternative :int =L.Tracking.Rotation.HORIZONTAL
	if from_to == Vector2i.ZERO:
		if cell_new_x == 0:
			alternative =L.Tracking.Rotation.VERTICAL
	return alternative

func sliding(is_sliding):
	if is_sliding is bool:
		is_sliding = int(is_sliding)
	current_map = personal_maps[is_sliding]

func jumping(is_jumping :bool):
	can_make_tracks = !is_jumping

func change_actions(new_action :String):
	if new_action is String:
		sliding(new_action == "Stunned")

#region    #===============================================================# DEBUG
@export_group("DEBUG")
@export var debug :bool
@onready var parent :AnzhuBeing = get_parent()
#endregion #===============================================================# DEBUG
