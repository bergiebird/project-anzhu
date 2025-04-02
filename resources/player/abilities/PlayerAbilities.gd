@icon("res://warehouse/_icons/node/icon_human_controller.png")
class_name Abilities extends Node #PlayerAbilities.gd

@onready var parent :AnzhuHuman
@onready var movement :Ability = $Movement
@onready var gun :Ability = $Gun
@onready var jump :Ability = $Jump
@onready var binos :Ability = $Binos
@export_group('Debug')
@export var debug_abilities :bool = false
@export var debugger_color :Color = Color("eaf1f0")
@onready var dcolor = debugger_color.to_html()
var init_finished :bool = false
var is_loaded :bool = false
var is_reloading :bool = false
var can_shoot :bool = true
var can_move :bool = true
var can_jump :bool = true
var is_efficient :bool = false
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		parent = node_dictionary["scene_root"]
		for child in get_children():
			child.parent = self
			child.anim = node_dictionary["Animations"]
		movement.move_stat_delivery(parent.move_speed)
		gun.reload_audio = node_dictionary['AudioManager'].audio_dictionary['reload']
		jump.elev = node_dictionary["ex_elevation"]
		jump.snow_tracker_node = node_dictionary['SnowTracker']
		binos.camera = node_dictionary['Camera']
		init_finished = true

func able()->void:
	if init_finished and can_move:
		parent.set_velocity(movement.move())
		jump.start_jump()
		if can_shoot: gun.shoot()
		else:         gun.reload()
	if is_reloading:
		gun.modify_reload()

func can_do_stuff_again()->void:
	can_shoot = true
	can_move = true
	can_jump = true

func cant_do_anything()->void:
	can_shoot = false
	can_move = false
	can_jump = false

func set_efficiency(has_efficiency :bool)->void:
	is_efficient = has_efficiency


func debug()->void:
	Debuggerton.enable_print(self.name, dcolor)
	debug_abilities = true
