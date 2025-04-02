@icon("res://resources/_singletons/nodeAudio/node_audio.png")
extends Node #NodeAudio.gd

var first_time :bool = true
var stored_passed_time :int
var sfx_gunshot :AudioStreamPlayer
var day_nighton :DayNighton = DayNighton
var audio_dictionary :Dictionary[String, Node]

func _ready()->void:
	assertions()
	for child in get_children():
		audio_dictionary[child.name] = child
	sfx_gunshot = audio_dictionary['Gunshot']
	audio_dictionary['BEGIN'].play()

func play_gunshot()->void:
	sfx_gunshot.play()

func play_time_music(passed_time :int)->void:
	audio_dictionary[day_nighton.TimeOfDay.keys()[passed_time]].play()

func _on_begin_finished() -> void:
	play_time_music(stored_passed_time)

func signal_connector()->void:
	Signalton.gunshot.connect(play_gunshot)
	day_nighton.time_progressed.connect(play_time_music)

func assertions()->void:
	assert(day_nighton, "day_nighton not found in NodeAudio.gd")
	assert(first_time, "first_time bool is not prepared properly in NodeAudio.gd")
