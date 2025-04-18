@icon("res://resources/_singletons/nodeAudio/node_audio.png")
extends Node #NodeAudio.gd

@export_enum("DayNight", "CyclingBGM") var audio_mode :int

var first_time :bool = true
var stored_passed_time :int
var sfx_gunshot :AudioStreamPlayer
var audio_dictionary :Dictionary[String, Node]

func _ready()->void:
	assertions()
	signaler()
	for child in get_children():
		audio_dictionary[child.name] = child
	sfx_gunshot = audio_dictionary['Gunshot']
	audio_dictionary['BEGIN'].play()

func play_gunshot()->void:
	sfx_gunshot.play()

func play_time_music(passed_time :int)->void:
	audio_dictionary[DayNighton.TimeOfDay.keys()[passed_time]].play()

func _on_begin_finished() -> void:
	play_time_music(stored_passed_time)

func signaler()->void:
	Signalton.gunshot.connect(play_gunshot)
	DayNighton.time_progressed.connect(play_time_music)

###
## DEBUG
###
func assertions()->void:
	assert(DayNighton, "day_nighton not found in NodeAudio.gd")
	assert(first_time, "first_time bool is not prepared properly in NodeAudio.gd")
