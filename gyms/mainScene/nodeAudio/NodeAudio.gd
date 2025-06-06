@icon("res://gyms/mainScene/nodeAudio/node_audio.png")
extends Node
class_name NodeAudio

enum AudioMode{
	DayNightMusic,  ## Plays music every 180 seconds that correlates with the time of day.
	CylcleBGMusic,  ## Cycles through 3 music tracks,
}

## This system is here simply to sample the differences between Cycling Music & time specific music
## Only reason this is here is simply because I don't know which is better. I love vibing to the Cycling music
## while other times I prefer complete silence with some indication that the time of day has changed.
@export var audio_mode :AudioMode = AudioMode.CylcleBGMusic
## Toggle the opening jingle, if set to D
@export var should_start_with_begin :bool = true

var store_new :int = -1
var store_old :int = -1
var audio_dictionary :Dictionary
var dictionary_size :int

@onready var bgm_begin :AudioStreamPlayer = %BEGIN
@onready var cycling_background_music :Node = $CylcleBGMusic
@onready var day_night_audio :Node = $DayNightMusic

func _ready():
	set_process(false)
	match audio_mode:
		AudioMode.DayNightMusic:
			initialize_DayNightMusic()
		AudioMode.CylcleBGMusic:
			initialize_CylcleBGMusic()
	if should_start_with_begin:
		bgm_begin.playing = true

func initialize_DayNightMusic(): # TODO: Doesnt
	for child :AudioStreamPlayer in day_night_audio.get_children():
		audio_dictionary[child.name] = child

func initialize_CylcleBGMusic():
	var index :int = 0
	for child :AudioStreamPlayer in cycling_background_music.get_children():
		audio_dictionary[index] = child
		index += 1
		child.finished.connect(play_new_bgm)
		dictionary_size = audio_dictionary.size()
	if should_start_with_begin:
		await bgm_begin.finished
	play_new_bgm(false)

func play_new_bgm(_scene_just_started :bool = true):
	while store_new == store_old:
		store_new =Libraryton.rng.randi_range(0, dictionary_size - 1)
	store_old = store_new
	audio_dictionary[store_old].playing = true

func play_time_music(passed_time :int = store_old):
	audio_dictionary[DayNighton.TimeOfDay.keys()[passed_time]].playing = true

#region # DEBUG
@export var debug :bool = false

#endregion
