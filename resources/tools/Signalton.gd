extends Node #Signalton.gd

var emit_for :Callable = Callable(self, "emit_signal")

signal loud_noise(who :AnzhuBeing, where :Vector2, noise_db :float)
signal gunshot
signal time_progressed
signal weather_changed
signal player_hit
signal reload_scene
signal toggle_debug_collision
signal toggle_debug_elevation
signal toggle_debug_invisible

var saved_state :bool = false

func _ready() -> void:
	reload_scene.connect(reload_current_scene)

func reload_current_scene()->void:
	saved_state = true
	var error :Error = get_tree().reload_current_scene()
	debug_scene_reloaded(error)


#region	DEBUG
var debug:bool = false
func debug_scene_reloaded(error :Error)->void:
	match error:
		OK:
			print('GOOD!')
#endregion
