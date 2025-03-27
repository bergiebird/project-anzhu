extends AudioManager #BearAudio.gd
@export_category('DEBUG')

@onready var sfx_hunt :AudioStreamPlayer2D = $Sfx_Hunt

func _reset_bgm()->void:
	sfx_hunt.volume_db = 0
	sfx_hunt.pitch_scale = 1
	count = 1

func increase_stakes(name_of_sfx :String)->void:
	if first_time:
		first_time = false
		return
	count *= 1.1
	sfx_hunt_count += 1
	if sfx_hunt_count >= 8: return
	sfx_hunt.volume_db += (count/100)
	sfx_hunt.pitch_scale += (count/100)

func parse_goal(new_goal :String)->void:
	if new_goal == "Hunt": return
	if new_goal == "Nothing" and sfx_hunt.is_playing(): sfx_hunt.stop()
