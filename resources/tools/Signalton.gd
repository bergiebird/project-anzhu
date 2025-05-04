extends Node #Signalton.gd

var emit_for :Callable = Callable(self, "emit_signal")

signal loud_noise(who :AnzhuBeing, where :Vector2, noise_db :float)
signal gunshot
signal time_progressed
signal weather_changed
signal player_hit
signal reload_scene

var saved_state :bool = false

func _ready() -> void:
	Debuggerton.signal_checker([
		reload_scene.connect(reload_current_scene)])
	_debug()

func reload_current_scene()->void:
	saved_state = true
	var error :Error = get_tree().reload_current_scene()
	debug_scene_reloaded(error)


###
##	DEBUG
###
var debug:bool = false
func _debug()->void:
	if debug:
		assert(loud_noise)
		assert(gunshot)
		assert(time_progressed)
		assert(weather_changed)
		assert(player_hit)
		assert(reload_scene)


func debug_scene_reloaded(error :Error)->void:
	match error:
		OK:
			print('GOOD!')
