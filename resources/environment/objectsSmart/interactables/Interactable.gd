@icon("res://resources/environment/objectsSmart/interactables/icon_interactable.png")
extends Node2D # Interactable.gd

signal interacted

@export var interaction_enter :String = "Press F to interact"
@export var interacted_with :String = "This is a note."
@export var interaction_exit :String = 'Have left the interaction zone'
@onready var area2d :Area2D = $Area2D
var player :Player

func _ready()->void:
	_debug()
	Debuggerton.signal_checker([
		area2d.body_entered.connect(_on_area_2d_body_entered),
		area2d.body_exited.connect(_on_area_2d_body_exited),
		Libraryton.player_reference.connect(func(ref :Player)->void: player = ref),
		interacted.connect(func()->void:_dprint(interacted_with))], debug)
	set_process(false)

func _on_area_2d_body_entered(_body :Player)->void:
	set_process(true)
	_dprint(interaction_enter)

func _process(_delta :float)->void:
	if Input.is_action_just_pressed('interact'):
		interacted.emit()

func _on_area_2d_body_exited(_body :Player)->void:
	set_process(false)
	_dprint(interaction_exit)

###
## DEBUG
###
@export_group('debug')
@export var debug :bool = false
@export var debug_color :Color = Swatchton.GREEN_FOREST

func _debug() ->void:
	if debug:
		Debuggerton.enable_print(self.name, debug_color)

func _dprint(message :String)->void:
	if debug:
		Debuggerton.dprint(message, debug_color)
