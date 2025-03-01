@icon("res://warehouse/_icons/node_2D/icon_audio.png")
extends Node2D #polar_bear_audio.gd

@onready var bgm_encounter :AudioStreamPlayer2D = $BgmEncounter
@onready var sfx_hurt :AudioStreamPlayer2D = $RoarHurt
@onready var sfx_spotted :AudioStreamPlayer2D = $RoarSpotted
@onready var sfx_lost_sight :AudioStreamPlayer2D = $LostSight
@onready var sfx_walk :AudioStreamPlayer2D = $Walk
@onready var sfx_run :AudioStreamPlayer2D = $Run
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


func _on_polar_bear_dead() -> void:
	sfx_hurt.play()


func _on_eyesight_enraged() -> void:
	sfx_spotted.play()


func _on_eyesight_lost_sight() -> void:
	sfx_lost_sight.play()

func _on_is_walking() -> void:
	if sfx_walk.is_playing():
		return
	sfx_walk.play()
	print('yarp')
