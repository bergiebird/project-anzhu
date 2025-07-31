extends Node2D
class_name ElevationManager

const OPAQUE: float = 1.0
const TRANSPARENT: float = 0.0
const MOD_A: String = "modulate:a"

var player: Player
var all_fogs: Dictionary[int, TileMapLayer]
var elevation: TileMapLayer:
	set(v): if v != elevation:
		elevation = v
		elevation.visible = false
		Sgnl.toggle_debug_elevation.connect(func(): elevation.visible = !elevation.visible)
var current_fogs: Array[TileMapLayer]:
	set(v):
		for i_value in v:
			current_fogs.erase(i_value)
		set_old_fogs()
		current_fogs = v
		set_new_fogs()


func _ready():
	visible = true
	elevation = $ElevationsLayer
	player = get_tree().get_first_node_in_group('player')
	player.publish_event.connect(func(func_name :String, data :Variant=null):Lib.Observe.subscribe_to_event(self, func_name, data))


func on_new_elevation(tile :int = 0):
	if is_first_run_through():
		_init_current_fogs(tile)
	elif is_not_exception_elevation(tile) and is_not_same_elevation(tile):
		set_current_fogs(tile)


func _init_current_fogs(_tile :int):
	for child:Node in get_children():
		if child is not ElevationsLayer:
			child.visible = true
			all_fogs[int(child.name)] = child
	set_current_fogs(_tile)


func set_current_fogs(_tile: int):
	var temp :Array[TileMapLayer] = []
	if all_fogs.has(_tile):
		temp.append(all_fogs[_tile])
		if all_fogs.has(_tile -1):
			temp.append(all_fogs[_tile - 1])
			if all_fogs.has(_tile - 2):
				temp.append(all_fogs[_tile - 2])
		current_fogs = temp


func __set_fog(this_fog: TileMapLayer, opacity: float, time: float=0.64):
	Buildton.tweener_deferred(this_fog, MOD_A, opacity, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)


func is_not_exception_elevation(_new_elevation :int):
	return !(_new_elevation == 0)


func is_not_same_elevation(_tile :int):
	return !(str(_tile) == current_fogs[0].name)


func is_first_run_through():
	return false if current_fogs else true


func set_new_fogs():
	for new_fog in range(current_fogs.size()):
		if new_fog == 2:
			__set_fog(current_fogs[new_fog], 0.85, 3)
		elif new_fog == 1:
			__set_fog(current_fogs[new_fog], 0.15, 3)
		else:
			__set_fog(current_fogs[new_fog], TRANSPARENT)


func set_old_fogs():
	for old_fog:TileMapLayer in current_fogs:
		__set_fog(old_fog, OPAQUE)
