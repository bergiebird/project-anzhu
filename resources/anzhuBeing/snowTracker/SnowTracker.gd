@icon("res://warehouse/icons/node/icon_grid.png")
class_name SnowTracker extends Node #SnowTracker.gd
enum AltRotation {HORIZONTAL, VERTICAL}
const MAX_SIZE :int = 3
const ATLAS_OFFSET :Vector2i = Vector2i(1,1)
var map_sliding :TileMapLayer
var map_moving :TileMapLayer
var is_sliding :bool = false:
	set(value): # This handles which map to use based on if they're sliding or not.
		if value != is_sliding:
			is_sliding = value
			sliding_updater()
var current_cells :Array[Vector2i] = []
var current_map :TileMapLayer
var can_make_tracks :bool = false
var abilities :Abilities
var personal_maps :Array[TileMapLayer]
@onready var parent :AnzhuBeing = get_parent()

func _ready() -> void:
	if parent.has_node('Abilities'):
		abilities = parent.get_node('Abilities')
		abilities.jumping.connect(func(needs_inverse:bool)->void: 
			print('snowtracking: ', !needs_inverse)
			can_make_tracks=!needs_inverse)
	parent.on_new_track_tile.connect(update_tracks)
	parent.was_struck.connect(func(): is_sliding=true)
	parent.hit_over.connect(func(): is_sliding=false)
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
	personal_maps = Builderton.create_trackMap_array(parent.name)
	map_moving = personal_maps[0]
	parent.personal_track_map = map_moving
	map_sliding = personal_maps[1]
	sliding_updater()
	can_make_tracks = true
	Libraryton.tracks_reference.disconnect(setup_maps)

func sliding_updater()->void:
	if is_sliding:
		current_map = map_sliding
	else:
		current_map = map_moving
