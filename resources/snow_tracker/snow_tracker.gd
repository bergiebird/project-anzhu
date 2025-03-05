@icon("res://warehouse/_icons/node/icon_grid.png")
class_name SnowTracker extends Node #snow_tracker.gd
@onready var parent: AnzhuCharacter = get_parent()
@onready var snow_layer :TileMapLayer = get_tree().get_first_node_in_group("snow")
const TRACK_TILES :Dictionary = {
	"WALK": {
		"LEFT_RIGHT":   Vector2i(1, 88),
		"UP_DOWN":      Vector2i(0, 89),
		"LEFT_UP":     Vector2i(2, 90),
		"LEFT_DOWN":  Vector2i(2, 88),
		"RIGHT_UP":    Vector2i(0, 90),
		"RIGHT_DOWN": Vector2i(0, 88),
		"_":            Vector2i(1,89),},
	"RUN": {
		"RIGHT_DOWN": Vector2i(8, 88),
		"LEFT_RIGHT":   Vector2i(9, 88),
		"UP_DOWN":      Vector2i(8, 89),
		"LEFT_DOWN":  Vector2i(10, 88),
		"LEFT_UP":     Vector2i(10, 90),
		"RIGHT_UP":    Vector2i(8, 90),
		"_":            Vector2i(1,89),}
}
const DIR_NONE :String = "NONE"
const DIR_UP :String = "UP"
const DIR_DOWN :String = "DOWN"
const DIR_LEFT :String = "LEFT"
const DIR_RIGHT :String = "RIGHT"
var previous_tile_pos :Vector2i = Vector2i(-1, -1)
var current_direction :String = DIR_RIGHT
var previous_direction :String = DIR_RIGHT
var is_running :bool = false

func _physics_process(delta :float)->void:
	update_snow_tracks(delta)

func update_snow_tracks(delta :float)->void:
	if parent == null or snow_layer == null: return
	var velocity :Vector2 = parent.velocity
	if parent.name == "PolarBear":
		print(velocity)
	if velocity.length() < 0.1:  return
	var current_tile_pos :Vector2i = snow_layer.local_to_map(parent.global_position)
	if current_tile_pos == previous_tile_pos:
		return
	if abs(velocity.x) > abs(velocity.y):
		current_direction = DIR_RIGHT if velocity.x > 0 else DIR_LEFT
	else:
		current_direction = DIR_UP if velocity.y > 0 else DIR_DOWN
	if previous_tile_pos != Vector2i(-1, -1) and previous_direction != DIR_NONE:
		place_track(previous_tile_pos)
	previous_tile_pos = current_tile_pos
	previous_direction = current_direction

func place_track(tile_pos :Vector2i)->void:
	snow_layer.set_cell(tile_pos, 0, TRACK_TILES["WALK"][get_track_type(previous_direction, current_direction)])

func get_track_type(from_dir :String, to_dir :String)->String:
	if from_dir == to_dir or (from_dir == DIR_LEFT and to_dir == DIR_RIGHT) or (from_dir == DIR_RIGHT and to_dir == DIR_LEFT):
		if from_dir == DIR_LEFT or from_dir == DIR_RIGHT: return "LEFT_RIGHT"
		if from_dir == DIR_UP or from_dir == DIR_DOWN:    return "UP_DOWN"
	if from_dir == DIR_LEFT:  return "RIGHT_DOWN" if to_dir == DIR_UP else "RIGHT_UP"
	if from_dir == DIR_RIGHT: return "LEFT_DOWN" if to_dir == DIR_UP else "LEFT_UP"
	if from_dir == DIR_UP:    return "LEFT_UP" if to_dir == DIR_LEFT else "RIGHT_UP" #GOOD
	if from_dir == DIR_DOWN:  return "LEFT_DOWN" if to_dir == DIR_LEFT else "RIGHT_DOWN" #GOOD
	return "_"
