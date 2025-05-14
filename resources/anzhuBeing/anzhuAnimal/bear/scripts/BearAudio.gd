extends AudioManager #BearAudio.gd

@onready var sfx_hunt :AudioStreamPlayer2D = $Sfx_Hunt
var sfx_hunt_count :int = 1
var count :float = 1.0
var first_time :bool = true

func _reset_bgm()->void:
	sfx_hunt.volume_db = 0
	sfx_hunt.pitch_scale = 1
	count = 1

func __was_just_struck()->void:
	if first_time:
		first_time = false
		return
	count *= 1.1
	sfx_hunt_count += 1
	if sfx_hunt_count < 8:
		sfx_hunt.volume_db += (count/100)
		sfx_hunt.pitch_scale += (count/100)

func __character_is_striking()->void:
	start_sfx("Strike")
