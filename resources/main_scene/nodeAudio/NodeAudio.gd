@icon("res://resources/main_scene/game/nodeAudio/node_audio.png")
extends Node #NodeAudio.gd
enum AudioMode{DayNightAudio, CyclingBackgroundMusic}
@export_enum("DayNightAudio", "CyclingBackgroundMusic") var audio_mode :int = 1

var first_time :bool = true
var store_new :int = -1
var store_old :int = -1
var audio_dictionary :Dictionary
var dictionary_size :int

func _ready()->void:
	assertions()
	set_process(false)
	match audio_mode:
		AudioMode.DayNightAudio:           
			initialize_DayNightAudio()
		AudioMode.CyclingBackgroundMusic:  
			initialize_CyclingBackgroundMusic()
	%BEGIN.play()

func initialize_DayNightAudio()->void:
	DayNighton.time_progressed.connect(play_time_music)
	for child in $DayNightAudio.get_children():
		audio_dictionary[child.name] = child
	audio_dictionary['BEGIN'].play()

func initialize_CyclingBackgroundMusic()->void:
	var index :int = 0
	for child in $CyclingBackgroundMusic.get_children():
		audio_dictionary[index] = child
		index += 1
		child.finished.connect(play_new_bgm)
	dictionary_size = audio_dictionary.size()
	await %BEGIN.finished
	print('begin finished')
	play_new_bgm(false)

func play_new_bgm(bol:bool = true)->void:
	if bol: await get_tree().create_timer(15.0).timeout
	print('processing new music')
	while store_new == store_old:
		store_new = Libraryton.random_range(0, dictionary_size - 1)
	store_old = store_new
	audio_dictionary[store_old].play()
	Signalton.weather_changed.emit()

func play_time_music(passed_time :int = store_old)->void:
	audio_dictionary[DayNighton.TimeOfDay.keys()[passed_time]].play()
	Signalton.weather_changed.emit()

###
## DEBUG
###
func assertions()->void:
	assert(first_time, "first_time bool is not prepared properly in NodeAudio.gd")
