




extends Timer #metranonme.gd
var test :int
@onready var audio_stream_player :AudioStreamPlayer = $AudioStreamPlayer
@export var count :int:
	set(incoming_value):
		if not incoming_value < 4:
				count = 1

func produce_metranome_tick_sound() -> void:
	count += 1
	test += 1
	printt("Tick" + str(count))
	print(test)
