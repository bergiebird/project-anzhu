@icon("res://warehouse/_icons/node_2D/icon_audio.png")
extends Node2D #polar_bear_audio.gd

@onready var bgm_encounter :AudioStreamPlayer2D = %EncounterMusic
var count :float = 1.0

func _on_shot() -> void:
	if bgm_encounter.is_playing():
		increase_stakes()
	else:
		bgm_encounter.play()

func _reset_bgm()->void:
	bgm_encounter.volume_db = 0
	bgm_encounter.pitch_scale = 1
	count = 1

func increase_stakes()->void:
	count *= 1.1
	bgm_encounter.volume_db += (count/100)
	bgm_encounter.pitch_scale += (count/100)

func parse_goal(new_goal :String)->void:
	if new_goal == "Hunt":
		return
	if new_goal == "Nothing":
		bgm_encounter.stop()
