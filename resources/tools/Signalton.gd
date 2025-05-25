extends Node
#Signalton.gd
signal update_console(String)
signal heal_player
signal loud_noise(who :AnzhuBeing, where :Vector2, noise_db :float)
signal gunshot
signal time_progressed
signal reload_scene
signal toggle_debug_collision
signal toggle_debug_elevation
signal toggle_debug_invisible

var saved_state :bool = false

func _ready():
	reload_scene.connect(reload_current_scene)

func reload_current_scene():
	saved_state = true
	var error :Error = get_tree().reload_current_scene()
	debug_scene_reloaded(error)


#region	DEBUG
var debug:bool = false
func debug_scene_reloaded(error :Error):
	match error:
		OK:
			print('GOOD!')
#endregion
