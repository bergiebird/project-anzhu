extends Node #Signalton.gd

signal gunshot
signal time_progressed
signal player_hit
signal reload_scene

var saved_state :bool = false

func _ready() -> void:
	reload_scene.connect(func(): saved_state = true)
