@icon("res://resources/player/abilities/move/icons8-exercise-100.png")
extends Ability #PlayerMovement.gd

@export_group('Movement')
@export var efficient_modifier :int = 15
@export var run_bonus :int = 20
var normal_speed :int
var directionary :Dictionary = Directon.directionary
var run_speed :int
var efficient_speed :int
var can_move :bool

func mover()->Vector2:
	var velocity :Vector2 = Vector2.ZERO
	can_move = false
	for direction in directionary:
		var vector = directionary[direction]['direction']
		if Inputon.move(direction):
			can_move = true
			if Inputon.aim(direction) and Directon.check_direction(direction):
				anim.just_play('run')
				velocity = vector * run_speed
				parent.set_efficiency(true)
			elif Inputon.inverse_aim(direction) and Directon.check_direction(direction):
				velocity = vector * normal_speed
				parent.set_efficiency(false)
			else:
				anim.just_play('walk')
				if Directon.check_direction(direction):
					velocity = vector * efficient_speed
					parent.set_efficiency(true)
				else:
					velocity = vector * normal_speed
					parent.set_efficiency(false)
			break
	if not can_move:
		for direction in directionary:
			if Input.is_action_pressed(directionary[direction]["aim"]):
				Directon.looking_where = directionary[direction]["enum"]
				anim.just_play('idle')
				break
		anim.just_play('idle')
	return velocity

func move_stat_delivery(incoming_speed :int)->void:
	normal_speed = incoming_speed
	efficient_speed = normal_speed + efficient_modifier
	run_speed = efficient_speed + run_bonus
