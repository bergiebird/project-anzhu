class_name AnzhuHuman extends AnzhuCharacter #_AnzhuHuman.gd

@onready var nightlight :PointLight2D = $Nightlight

func character_ready()->void:
	add_to_group('human')

	human_ready()
func human_ready()->void:pass
