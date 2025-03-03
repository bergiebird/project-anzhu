extends Node #Audioton.gd
#@onready var main_audio_node :Node =
var audio_buses :Array[String] = []

func _ready():
	for index in range(AudioServer.bus_count):
		audio_buses.append(AudioServer.get_bus_name(index))

func toggle_mute_on_node(node_name :String, )->void:
	pass
