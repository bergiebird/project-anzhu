@icon("res://warehouse/_icons/misc/cardinal_movement.png")
extends Node #player_movement.gd

signal efficiency_check(report :bool)
@export_group('Movement')
@export var normal_speed :int = 20
@export var efficient_modifier :int = 15
@export var run_bonus :int = 20
var directions :Dictionary
var run_speed :int
var efficient_speed :int

@onready var parent :AnzhuPlayer = get_parent().get_parent()
@onready var anim: AnimatedSprite2D = %Animations
@onready var velocity :Vector2
@onready var has_movement :bool
@onready var enumer :Enumerton = Enumerton


func _ready()->void:
	efficient_speed = normal_speed + efficient_modifier
	run_speed = efficient_speed + run_bonus
	directions = enumer.character_directions_bible


func move()->void:
	velocity = Vector2.ZERO
	has_movement = false
	for dir_name in ["NORTH", "SOUTH", "WEST", "EAST"]:
		var dir = directions[dir_name]
		if Input.is_action_pressed(dir["move_action"]):
			has_movement = true
			var opposite_dir = directions[dir["opposite"]]
			if Input.is_action_pressed(dir["aim_action"]) and enumer.looking_where == dir["enum"]:
				anim.start_run()
				velocity = dir["vector"] * run_speed
				efficiency_check.emit(true)
			elif Input.is_action_pressed(opposite_dir["aim_action"]) and enumer.looking_where == dir["enum"]:
				velocity = dir["vector"] * normal_speed
				efficiency_check.emit(false)
			else:
				anim.start_walk()
				if enumer.looking_where == dir["enum"]:
					velocity = dir["vector"] * efficient_speed
					efficiency_check.emit(true)
				else:
					velocity = dir["vector"] * normal_speed
					efficiency_check.emit(false)
			break
	if not has_movement:
		for dir_name in directions:
			if Input.is_action_pressed(directions[dir_name]["aim_action"]):
				enumer.looking_where = directions[dir_name]["enum"]
				anim.start_idle()
				break
		if parent.can_fire:
			anim.start_idle()
	parent.set_velocity(velocity)
