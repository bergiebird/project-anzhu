@icon("res://gyms/mainScene/nodeAudio/node_audio.png")
class_name NodeAudio extends Node

enum AudioMode{DayNightAudio, CyclingBackgroundMusic}

@export var audio_mode :AudioMode = AudioMode.CyclingBackgroundMusic
@export var should_start_with_begin :bool = true
var store_new :int = -1
var store_old :int = -1
var audio_dictionary :Dictionary
var dictionary_size :int

@onready var bgm_begin :AudioStreamPlayer = %BEGIN

func _ready()->void:
	set_process(false)
	match audio_mode:
		AudioMode.DayNightAudio:
			initialize_DayNightAudio()
		AudioMode.CyclingBackgroundMusic:
			initialize_CyclingBackgroundMusic()
	if should_start_with_begin:
		bgm_begin.playing = true

func initialize_DayNightAudio()->void:
	DayNighton.time_progressed.connect(play_time_music)
	for child :Node in $DayNightAudio.get_children():
		audio_dictionary[child.name] = child

func initialize_CyclingBackgroundMusic()->void:
	var index :int = 0
	for child :AudioStreamPlayer in $CyclingBackgroundMusic.get_children():
		audio_dictionary[index] = child
		index += 1
		child.finished.connect(play_new_bgm)
		dictionary_size = audio_dictionary.size()
	await bgm_begin.finished
	play_new_bgm(false)

func play_new_bgm(scene_just_started:bool = true)->void:
	if scene_just_started:
		await get_tree().create_timer(15.0).timeout
	while store_new == store_old:
		store_new = Libraryton.rng.randi_range(0, dictionary_size - 1)
	store_old = store_new
	audio_dictionary[store_old].playing = true
	Signalton.weather_changed.emit()

func play_time_music(passed_time :int = store_old)->void:
	audio_dictionary[DayNighton.TimeOfDay.keys()[passed_time]].playing = true
	Signalton.weather_changed.emit()

#region # DEBUG
@export var debug :bool = false

#endregion
