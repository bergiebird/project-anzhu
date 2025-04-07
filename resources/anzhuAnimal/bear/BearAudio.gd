extends AudioManager #BearAudio.gd

@onready var sfx_hunt :AudioStreamPlayer2D = $Sfx_Hunt

func signal_connector():
	Audioton.permission_granter.connect(play_hunt_music)

func play_hunt_music(which_bear :Bear)->void:
	if which_bear == parent:
		sfx_hunt.play()

func _reset_bgm()->void:
	sfx_hunt.volume_db = 0
	sfx_hunt.pitch_scale = 1
	count = 1

func was_just_hit()->void:
	if first_time:
		first_time = false
		return
	count *= 1.1
	sfx_hunt_count += 1
	if sfx_hunt_count >= 8: return
	sfx_hunt.volume_db += (count/100)
	sfx_hunt.pitch_scale += (count/100)

func character_is_striking()->void:
	start_sfx("Strike")
