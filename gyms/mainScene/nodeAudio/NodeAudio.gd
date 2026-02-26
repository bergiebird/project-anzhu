@icon("res://gyms/mainScene/nodeAudio/node_audio.png")

class_name NodeAudio
extends Node


enum AudioMode{
	DayNightMusic,  ## Plays music every 180 seconds that correlates with the time of day.
	CycleBGMusic,  ## Cycles through 3 music tracks,
}

## This system is here to sample the differences between Cycling Music & time specific music.
## I don't know which is better. I love vibing to the Cycling music while other times
## I prefer complete silence with some indication that the time of day has changed.
@export var audio_mode: AudioMode = AudioMode.CycleBGMusic

## Toggle the opening jingle
@export var should_start_with_begin: bool = true

@export_group('Debug')
@export var debug: bool = false

var store_new: int = -1
var store_old: int = -1
var audio_dictionary: Dictionary
var dictionary_size: int

@onready var bgm_begin: AudioStreamPlayer = %BEGIN
@onready var cycling_background_music: Node = $CycleBGMusic
@onready var day_night_audio: Node = $DayNightMusic


@onready var sfx_collect: AudioStreamPlayer = $Sfx/Collect


func _ready():
	set_process(false)
	Sgnl.music_muted.connect(_mute_music)
	Sgnl.sfx_requested.connect(_play_sfx)
	match audio_mode:
		AudioMode.DayNightMusic:
			initialize_DayNightMusic()
		AudioMode.CycleBGMusic:
			initialize_CycleBGMusic()
	if should_start_with_begin:
		bgm_begin.playing = true

func _mute_music(should_mute: bool) -> void:
	AudioServer.set_bus_mute(1, should_mute)


func _play_sfx():
	print("PLAYED")
	var new_sfx: Node = sfx_collect.duplicate()
	add_child(new_sfx)
	new_sfx.play()
	await new_sfx.finished
	new_sfx.queue_free()


func initialize_DayNightMusic(): # TODO: Doesnt ??
	for child:AudioStreamPlayer in day_night_audio.get_children():
		audio_dictionary[child.name] = child


func initialize_CycleBGMusic():
	var index: int = 0
	for child:AudioStreamPlayer in cycling_background_music.get_children():
		audio_dictionary[index] = child
		index += 1
		child.finished.connect(play_new_bgm)
		dictionary_size = audio_dictionary.size()
	if should_start_with_begin:
		await bgm_begin.finished
	play_new_bgm(false)


func play_new_bgm(_scene_just_started: bool = true):
	while store_new == store_old:
		store_new =Libraryton.rng.randi_range(0, dictionary_size - 1)
	store_old = store_new
	audio_dictionary[store_old].playing = true
