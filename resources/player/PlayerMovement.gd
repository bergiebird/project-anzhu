@icon("res://warehouse/_icons/misc/cardinal_movement.png")
extends Ability #PlayerMovement.gd

@export_group('Movement')
@export var efficient_modifier :int = 15
@export var run_bonus :int = 20
var normal_speed :int
var directions :Dictionary
var run_speed :int
var efficient_speed :int
var local_velocity :Vector2
var has_movement :bool
@onready var directon :Directon = Directon
@onready var InputClass :Object = Input

func move()->Vector2:
	reset_movement_variables()
	for direction_name in directions:
		var dir = directions[direction_name]
		if InputClass.is_action_pressed(dir["move_action"]):
			has_movement = true
			if InputClass.is_action_pressed(dir["aim_action"]) and directon.looking_where == dir["enum"]:
				anim.start_run()
				local_velocity = dir["vector"] * run_speed
				parent.set_efficiency(true)
			elif InputClass.is_action_pressed(directions[dir["opposite"]]["aim_action"]) and directon.looking_where == dir["enum"]:
				local_velocity = dir["vector"] * normal_speed
				parent.set_efficiency(false)
			else:
				anim.start_walk()
				if directon.looking_where == dir["enum"]:
					local_velocity = dir["vector"] * efficient_speed
					parent.set_efficiency(true)
				else:
					local_velocity = dir["vector"] * normal_speed
					parent.set_efficiency(false)
			break
	if not has_movement:
		for direction_name in directions:
			if InputClass.is_action_pressed(directions[direction_name]["aim_action"]):
				directon.looking_where = directions[direction_name]["enum"]
				anim.start_idle()
				break
		if parent.can_shoot:
			anim.start_idle()
	return local_velocity

func reset_movement_variables()->void:
	local_velocity = Vector2.ZERO
	has_movement = false

func move_stat_delivery(incoming_speed :int)->void:
	normal_speed = incoming_speed
	efficient_speed = normal_speed + efficient_modifier
	run_speed = efficient_speed + run_bonus
	directions = directon.character_directions_bible
