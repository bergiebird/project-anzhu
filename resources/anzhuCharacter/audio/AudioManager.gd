@icon("res://warehouse/icons/node_2D/icon_audio.png")
class_name AudioManager extends Node2D #AudioManager.gd

var first_time :bool = true
var count :float = 1.0
var sfx_hunt_count :int = 1
var audio_dictionary :Dictionary[String, Node] = {}
var audio_string :String = "Sfx_"
@export var debug_audio :bool = false

func _ready()->void:
	for child in get_children():
		if child is AudioStreamPlayer2D:
			audio_dictionary[child.name] = child


func start_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).play()
func stop_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).stop()
func get_is_playing(name_of_sfx :String)->bool:
	return audio_dictionary.get(audio_string + name_of_sfx).is_playing()

func debug()->void:
	print_rich('[color=ebb85b]Audio debugging enabled . . .[/color]')
	debug_audio = true
