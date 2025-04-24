extends Node #Signalton.gd

signal loud_noise(who :AnzhuBeing, where :Vector2, noise_db :float)
signal gunshot
signal time_progressed
signal weather_changed
signal player_hit
signal reload_scene

var saved_state :bool = false

func _ready() -> void:
	reload_scene.connect(func(): saved_state = true)
