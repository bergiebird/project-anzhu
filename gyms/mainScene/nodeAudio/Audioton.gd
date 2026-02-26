extends Node #Audioton.gd

var audio_buses: Array[String] = []
var bear_boogie_mode: bool = false

func _ready()->void:
	for index: int in range(AudioServer.bus_count):
		audio_buses.append(AudioServer.get_bus_name(index))
		print(index)

func can_bear_boogie(_which_bear :AnzhuAnimal)->bool:
	if not bear_boogie_mode:
		bear_boogie_mode = true
		return true
	return false

func boogie_bear_dead()->void:
	bear_boogie_mode = false
