@icon("res://resources/player/abilities/move/icons8-exercise-100.png")
extends Ability #PlayerMovement.gd

@export_group('Movement')
@export var efficient_modifier :int = 15
@export var run_bonus :int = 20
var normal_speed :int
var cardinal_dictionary :Dictionary
var run_speed :int
var efficient_speed :int
var move_velocity :Vector2
var has_movement :bool
@onready var D :Directon = Directon
@onready var I :Object = Input

func move()->Vector2:
	move_velocity = Vector2.ZERO
	has_movement = false
	for direction_name in cardinal_dictionary:
		var direction :Dictionary = cardinal_dictionary[direction_name]
		if I.is_action_pressed(direction["move_action"]):
			has_movement = true
			if I.is_action_pressed(direction["aim_action"]) and D.looking_where == direction["enum"]:
				anim.just_play('run')
				move_velocity = direction["vector"] * run_speed
				parent.set_efficiency(true)
			elif I.is_action_pressed(cardinal_dictionary[direction["opposite"]]["aim_action"]) and D.looking_where == direction["enum"]:
				move_velocity = direction["vector"] * normal_speed
				parent.set_efficiency(false)
			else:
				anim.just_play('walk')
				if D.looking_where == direction["enum"]:
					move_velocity = direction["vector"] * efficient_speed
					parent.set_efficiency(true)
				else:
					move_velocity = direction["vector"] * normal_speed
					parent.set_efficiency(false)
			break
	if not has_movement:
		for direction_name in cardinal_dictionary:
			if I.is_action_pressed(cardinal_dictionary[direction_name]["aim_action"]):
				D.looking_where = cardinal_dictionary[direction_name]["enum"]
				anim.just_play('idle')
				break
		anim.just_play('idle')
	return move_velocity



func move_stat_delivery(incoming_speed :int)->void:
	normal_speed = incoming_speed
	efficient_speed = normal_speed + efficient_modifier
	run_speed = efficient_speed + run_bonus
	cardinal_dictionary = D.character_directions_bible
