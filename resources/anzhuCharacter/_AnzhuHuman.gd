
class_name AnzhuHuman extends AnzhuCharacter #_AnzhuHuman.gd

@onready var nightlight :PointLight2D = $Nightlight

@export_group('Energy')
@export var max_energy :int = 10
@export var regen_rate :int = 1

func ready()->void:
	add_to_group('human')
	add_to_group('player')
	human_ready()
func human_ready()->void:pass
