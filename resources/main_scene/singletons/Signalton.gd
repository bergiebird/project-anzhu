extends Node #Signalton.gd

signal loud_noise(who :AnzhuBeing, where :Vector2, noise_db :float)
signal gunshot
signal time_progressed
signal weather_changed
signal player_hit
signal reload_scene

var saved_state :bool = false

func _ready() -> void:
	Debuggerton.signal_checker([
		reload_scene.connect(func()->void: saved_state = true)])
	_debug()


func _input(event: InputEvent) -> void:
	if event.is_action_released('quit'):
		reload_scene.emit()



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
