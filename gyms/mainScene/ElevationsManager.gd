extends CanvasGroup
class_name ElevationManager

const OPAQUE :float = 1.0
const TRANSPARENT :float = 0.0
const MOD_A :String = "modulate:a"
var player :Player
var elevation:TileMapLayer:
	set(value): if value != elevation:
		elevation = value
		elevation.visible = false
		Signalton.toggle_debug_elevation.connect(func(): elevation.visible = !elevation.visible)
var all_fogs :Dictionary[int, TileMapLayer]
var current_fogs :Array[TileMapLayer]:
	set(value):
		for i_value in value:
			current_fogs.erase(i_value)
		for old_fog in current_fogs:
			__set_fog(old_fog,  OPAQUE)
		current_fogs = value
		for new_fog in range(current_fogs.size()):
			if new_fog == 2:
				__set_fog(current_fogs[new_fog], 0.5, 3)
			elif new_fog == 1:
				__set_fog(current_fogs[new_fog], TRANSPARENT, 2)
			else:
				__set_fog(current_fogs[new_fog], TRANSPARENT)

func _ready():
	visible = true
	elevation = $ElevationsLayer
	Signalton.player_reference.connect(collect_player_reference)

func on_new_elevation( tile:int =0 ):
	if is_first_run_through():
		_init_current_fogs(tile)
	elif is_not_exception_elevation(tile) and is_not_same_elevation(tile):
		set_current_fogs(tile)


func _init_current_fogs(_tile:int):
	for child in get_children():
		if child is not ElevationsLayer:
			all_fogs[int(child.name)] = child
	set_current_fogs(_tile)

func set_current_fogs(_tile:int):
	var temp :Array[TileMapLayer] = []
	if all_fogs.has(_tile):
		temp.append(all_fogs[_tile])
		if all_fogs.has(_tile -1):
			temp.append(all_fogs[_tile - 1])
			if all_fogs.has(_tile - 2):
				temp.append(all_fogs[_tile - 2])
		current_fogs = temp



func __set_fog(this_fog:TileMapLayer, opacity:float, time:float=0.64):
		Builderton.tweener_deferred(this_fog, MOD_A, opacity, time,
												Tween.TRANS_LINEAR, Tween.EASE_OUT)

func collect_player_reference( ref:Player ):
	player = ref
	player.publish_event.connect(func(func_name:String, data:Variant=null):L.Observe.subscribe_to_event(self, func_name, data))
	Signalton.player_reference.disconnect(collect_player_reference)
func is_not_exception_elevation(_new_elevation:int):  return !(_new_elevation == 0)
func is_not_same_elevation(_tile:int):                return !(str(_tile) == current_fogs[0].name)
func is_first_run_through():                          return false if current_fogs else true
