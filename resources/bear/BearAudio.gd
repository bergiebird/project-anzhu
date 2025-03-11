@icon("res://warehouse/_icons/node_2D/icon_audio.png")
extends Node2D #BearAudio.gd

@onready var sfx_hunt :AudioStreamPlayer2D = $Sfx_Hunt

var first_time :bool = true
var count :float = 1.0
var sfx_hunt_count :int = 1
var audio_dictionary :Dictionary = {}
var audio_string :String = "Sfx_"

func _ready()->void:
	for child in get_children():
		if child is AudioStreamPlayer2D:
			audio_dictionary[child.name] = child


func _reset_bgm()->void:
	sfx_hunt.volume_db = 0
	sfx_hunt.pitch_scale = 1
	count = 1

func increase_stakes(name_of_sfx :String)->void:
	if first_time:
		first_time = false
		return
	count *= 1.1
	sfx_hunt_count += 1
	if sfx_hunt_count >= 8:
		return
	sfx_hunt.volume_db += (count/100)
	sfx_hunt.pitch_scale += (count/100)

func parse_goal(new_goal :String)->void:
	if new_goal == "Hunt":
		return
	if new_goal == "Nothing" and sfx_hunt.is_playing():
		sfx_hunt.stop()

func start_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).play()
func stop_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).stop()
func get_is_playing(name_of_sfx :String)->bool:
	return audio_dictionary.get(audio_string + name_of_sfx).is_playing()
