extends Node
#Buildton.gd
## Builder Pattern: "Separate the construction of a complex object from its representation
## so that the same construction process can create different representations." - Design Patterns Pg[97]
#=====================================================#=====================================================#
#region TRACKS
## Creates a TileMapLayer, places it as a child of %Tracks, and returns the reference
## %Tracks tells Buildton its reference.

const tracks_PATH_START: String = "res://resources/anzhuBeing/snowTracker/"
const tracks_PATH_END: String = ".tres"
const MOVE_PATH_END: String = "_move.tres"
const SLIDE_PATH_END: String = "_slide.tres"
var tracks :CanvasGroup

func _ready():
	Dbgr.signal_checker([
		Sgnl.tracks_reference.connect(func(ref :CanvasGroup)->void: tracks = ref)])

## Keep here for the constants
func create_trackMap_array(who: String)->Array[TileMapLayer]:
	return [track_map(who, MOVE_PATH_END), track_map(who, SLIDE_PATH_END)]

func track_map(who: String, PATH_END: String)->TileMapLayer:
	var just_who: String = Libraryton.remove_digits_from_string(who.to_lower())
	var tile_map :TileMapLayer = TileMapLayer.new()
	var tile_set :TileSet = load(tracks_PATH_START + just_who + PATH_END)
	tile_map.tile_set  = tile_set
	tile_map.name = who + PATH_END
	tracks.add_child(tile_map)
	return tile_map
#endregion
#region TWEENS
var active_tweens: Dictionary[String,Tween] = {}

func tweener_deferred(object: Object, property: String, end_result :Variant, time: float, trans_enum :Tween.TransitionType=Tween.TRANS_LINEAR, ease_enum :Tween.EaseType=Tween.EASE_IN_OUT)->PropertyTweener:
	return call_deferred("tweener", object, property, end_result, time, trans_enum, ease_enum)

func tweener(object: Object, property: String, end_result :Variant, time: float, trans_enum :Tween.TransitionType=Tween.TRANS_LINEAR, ease_enum :Tween.EaseType=Tween.EASE_IN_OUT)->PropertyTweener:
	var tween :Tween = create_tween()
	var key: String = kill_tweener(object,property)
	active_tweens[key] = tween
	return active_tweens[key].tween_property(object, property, end_result, time).set_trans(trans_enum).set_ease(ease_enum)


func kill_tweener(object: Object, property: String)->String:
	var key: String = get_key(object,property)
	if active_tweens.has(key) and active_tweens[key].is_valid():
		active_tweens[key].kill()
	return key

func get_key(object: Object, property:String)->String:
	return str(object.get_instance_id()) + property
#endregion
