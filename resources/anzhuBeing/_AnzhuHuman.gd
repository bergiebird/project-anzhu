class_name AnzhuHuman extends AnzhuBeing #_AnzhuHuman.gd

signal gun_reloaded
signal reload_finished


func character_ready()->void:
	add_to_group('human')
	human_ready()



func human_ready()->void:pass
