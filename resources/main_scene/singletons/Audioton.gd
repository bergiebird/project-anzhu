extends Node #Audioton.gd

signal permission_granter(which_bear :Bear)
var audio_buses :Array[String] = []
var bear_boogie_mode :bool = false

func _ready()->void:
	for index :int in range(AudioServer.bus_count):
		audio_buses.append(AudioServer.get_bus_name(index))


###
## BEAR CHASE
###
func can_bear_boogie(which_bear :AnzhuAnimal)->void:
	if not bear_boogie_mode:
		bear_boogie_mode = true
		permission_granter.emit(which_bear)

func boogie_bear_dead()->void:
	bear_boogie_mode = false
