@icon("res://warehouse/_icons/node/icon_sound.png")
extends Node #NodeAudio.gd

@onready var sfx_gunshot :AudioStreamPlayer

var day_nighton :DayNighton = DayNighton
var first_time :bool = true
var stored_passed_time :int
var audio_dictionary :Dictionary[String, Node]

func _ready()->void:
	Signalton.gunshot.connect(play_gunshot)
	day_nighton.time_progressed.connect(play_time_music)
	for child in get_children():
		audio_dictionary[child.name] = child
	sfx_gunshot = audio_dictionary['Gunshot']

func play_gunshot()->void:
	sfx_gunshot.play()

func play_time_music(passed_time :int)->void:
	var dn_music :String = day_nighton.TimeOfDay.keys()[passed_time]
	if first_time:
		print('begin')
		first_time = false
		audio_dictionary['BEGIN'].play()
		print(audio_dictionary['BEGIN'].get_playback_position())
		stored_passed_time = passed_time
		return
	print(dn_music)
	if dn_music == 'DAWN' or dn_music == 'DUSK':
		await get_tree().create_timer(75.0).timeout
		print('dawn or dusk')
	audio_dictionary[dn_music].play()

func _on_begin_finished() -> void:
	play_time_music(stored_passed_time)
