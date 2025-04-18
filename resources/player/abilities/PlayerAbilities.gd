@icon("res://warehouse/_icons/node/icon_human_controller.png")
class_name Abilities extends Node2D #PlayerAbilities.gd
signal start_reload
signal modified_reload
signal is_jumping
signal finished_jumping
var init_finished :bool = false
var is_loaded :bool = true
var is_reloading :bool = false
var can_shoot :bool = true
var can_move :bool = true
var can_jump :bool = true
var is_efficient :bool = false
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		for child in get_children():
			child.parent = self
			child.grandparent = parent
			child.anim = node_dictionary["Animations"]
		movement.move_stat_delivery(parent.move_speed)
		init_finished = true
@onready var parent :AnzhuHuman = get_parent()
@onready var anim = %Animations
@onready var movement :Ability = $Movement
@onready var gun = $Gun
@onready var jump :Ability = $Jump
@onready var binos :Ability = $Binos

func _ready() -> void:
	signaler()

func able()->void:
	if init_finished and can_move:
		parent.set_velocity(movement.mover())
		jump.jump()
		if can_shoot and is_loaded:
			gun.shoot()
		else:
			gun.reload()
	if is_reloading:
		gun.modify_reload()

func can_do_stuff(bol :bool)->void:
	can_shoot = bol
	can_move = bol
	can_jump = bol

func set_efficiency(has_efficiency :bool)->void:
	is_efficient = has_efficiency

func reloaded()->void:
	is_reloading = false
	is_loaded = true
	can_do_stuff(true)

func signaler()->void:
	is_jumping.connect(func(): can_do_stuff(false))
	finished_jumping.connect(func(): can_do_stuff(true))
	start_reload.connect(started_reload)
	anim.reloaded.connect(reloaded)
	Signalton.gunshot.connect(after_gunshot)

func started_reload()->void:
	can_move = false
	is_reloading = true

func after_gunshot()->void:
	can_shoot = false
	is_loaded = false
	can_move = false
	await get_tree().create_timer(gun.shoot_cooldown).timeout
	can_move = true

###
##DEBUG
###
@export_group('Debug')
@export var debug_abilities :bool = false
@export var debugger_color :Color = Color("eaf1f0")
@onready var dcolor = debugger_color.to_html()

func debug()->void:
	Debuggerton.enable_print(self.name, dcolor)
	debug_abilities = true
