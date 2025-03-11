extends Node #Audioton.gd

var audio_buses :Array[String] = []
var exclusive_bear_list :Array[Node]
signal permission_granter(permission :bool)
var bear_boogie_mode :bool = false


func _ready():
	for index in range(AudioServer.bus_count):
		audio_buses.append(AudioServer.get_bus_name(index))
	exclusive_bear_list = get_tree().get_nodes_in_group("bear")

func can_bear_boogie()->bool:
	return true
