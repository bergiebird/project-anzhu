@icon("res://resources/player/abilities/gun/icons8-sniper-rifle-100.png")
extends Ability #Gun.gd

var reload_audio
@export var shoot_cooldown :float = 0.4
@export var modified_speed_up :float = 0.16
@onready var I :Object = Input
@onready var S :Signalton = Signalton

func reload()->void:
	if I.is_action_just_pressed('gun'):
		if not parent.is_loaded:
			parent.can_move = false
			parent.is_reloading = true
			anim.start_reload_animation()

func modify_reload()->void:
	if I.is_action_just_pressed('spacebar'):
		if parent.is_reloading:
			anim.speed_scale += modified_speed_up
			reload_audio.pitch_scale += modified_speed_up

func shoot()->void:
	if I.is_action_just_released('gun'):
		parent.can_shoot = false
		parent.can_move = false
		S.gunshot.emit()
		await get_tree().create_timer(shoot_cooldown).timeout
		parent.can_move = true
