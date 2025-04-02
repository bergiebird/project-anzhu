extends Node #Signalton.gd

signal gunshot
signal time_progressed
signal player_hit
signal reload_scene

func _ready() -> void:
	reload_scene.connect(save_this)

var saved_state :bool = false
func save_this()->void:
	saved_state = true
