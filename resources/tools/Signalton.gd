extends Node
#Signalton.gd
signal update_console(String)
signal heal_player
signal loud_noise(who :AnzhuBeing, where :Vector2, noise_db :float)
signal gunshot
signal reload_scene
signal toggle_debug_collision
signal toggle_debug_elevation
signal toggle_debug_invisible
signal on_new_tile(Vector2i)
signal new_hour
signal new_hour_name(String)
signal new_hour_melatonin(int)
signal time_dictionary_delivery(Dictionary)
signal new_hour_nightlight(bool)
signal new_hour_campfire(float)

#region    #=================================================================# References
## Simple signals to give out the reference to anyone who wants it in the scene.
## reference_emitter handles emitting from all signals here.
signal player_reference(player_ref :Player)
signal entities_reference(entities_ref :CanvasGroup)
signal elevation_reference(elevation_ref :ElevationsLayer)
signal tracks_reference(tracks_ref :CanvasGroup)
signal props_reference(props_ref :TileMapLayer)
signal console_reference(console :RichTextLabel)
signal snowfall_reference(snowfall_ref :GPUParticles2D)

var player :Player

func reference_emitter_deferred(ref_signal :String, ref :Node, should_debug :bool=false)->void:
	Callable(self, "reference_emitter").bind(ref_signal, ref, should_debug).call_deferred()

func reference_emitter(ref_signal :String, ref :Node, should_debug:bool=false)->void:
	if ref is Player:
		player = ref
	var error :Error = emit_signal(ref_signal, ref)
	if should_debug:
		printt(ref_signal, "was emitted with reference: ", ref, "Error value: ", error )

#endregion #================================================================# References


var saved_state :bool = false

func _ready():
	reload_scene.connect(reload_current_scene)

func reload_current_scene():
	saved_state = true
	var error :Error = get_tree().reload_current_scene()
	debug_scene_reloaded(error)

#region    #=================================================================# Debug
var debug:bool = false
func debug_scene_reloaded(error :Error):
	match error:
		OK:
			print('GOOD!')
#endregion#=================================================================# Debug
