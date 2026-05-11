extends Node
class_name AudioBearMusic

var current_bear_music: AudioStreamPlayer2D
var player: Player
var current_bears_chasing: Array[AudioStreamPlayer2D] = []

func _ready() -> void:
	set_process(false)
	Sgnl.bear_chasing.connect(_on_bear_chasing)


func _process(_delta: float) -> void:
	if !player:
		player = Player.ref
	var closest_bear_music: AudioStreamPlayer2D
	var closest_dist: float = INF
	var current_closest_dist: float = INF
	if current_bear_music:
		current_closest_dist = player.global_position.distance_squared_to(current_bear_music.global_position)
	for bear_music: AudioStreamPlayer2D in current_bears_chasing:
		var dist: float = player.global_position.distance_squared_to(bear_music.global_position)
		if dist <= closest_dist && dist <= current_closest_dist:
			closest_dist = dist
			closest_bear_music = bear_music
		if bear_music != current_bear_music:
			bear_music.volume_db = -80.0
	if current_bear_music != closest_bear_music:
		print("NEW CURREN BEAR")
		var playback_position: float = 0.0
		if current_bear_music:
			playback_position = current_bear_music.get_playback_position()
		closest_bear_music.volume_db = 0.0
		current_bear_music = closest_bear_music
		closest_bear_music.play(playback_position)


func _on_bear_chasing(is_bear_chasing: bool, which_bear: AudioStreamPlayer2D) -> void:
	if is_bear_chasing:
		current_bears_chasing.append(which_bear)
		set_process(true)
	else:
		current_bears_chasing.erase(which_bear)
		if current_bears_chasing.is_empty():
			set_process(false)
