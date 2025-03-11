@icon("res://warehouse/_icons/node/icon_human_controller.png")
class_name Abilities extends Node #PlayerAbilities.gd

@onready var parent :AnzhuHuman
@onready var movement :Node = $Movement
@onready var gun :Node = $Gun
@onready var jump :Node = $Jump
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		parent = node_dictionary["parent"]
		for child in get_children():
			child.parent = self
			child.anim = node_dictionary["Animations"]
		movement.move_stat_delivery(parent.move_speed)
		jump.jump_stat_delivery(node_dictionary["ex_elevation"])
		capable = true

var capable :bool = false
var needs_reload :bool = false
var can_shoot :bool = true
var can_move :bool = true
var can_jump :bool = true
var is_efficient :bool = false

func able()->void:
	if not capable: return
	if can_move:
		parent.set_velocity(movement.move())
		jump.start_jump()
	if can_shoot:
		gun.shoot()
	else:
		gun.reload()

func can_do_stuff_again()->void:
	can_shoot = true
	can_move = true
	can_jump = true

func cant_do_anything()->void:
	can_shoot = false
	can_move = false
	can_jump = false


func set_efficiency(boool :bool)->void:
	is_efficient = boool
