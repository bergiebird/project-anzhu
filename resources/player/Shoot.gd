@icon("res://warehouse/_icons/misc/icons8-sniper-rifle-100.png")
extends Ability #Shoot.gd

signal start_reload()

@export var shoot_cooldown :float = 0.4
@onready var InputClass :Object = Input

func reload()->void:
	if InputClass.is_action_just_pressed('reload'):
		if not parent.needs_reload:
			parent.can_move = false
			start_reload.emit() #Should create a reload minigame here

func shoot()->void:
	if InputClass.is_action_just_released('shoot'):
		Signalton.gunshot.emit()
		parent.can_shoot = false
		parent.can_move = false
		await get_tree().create_timer(shoot_cooldown).timeout
		parent.can_move = true
