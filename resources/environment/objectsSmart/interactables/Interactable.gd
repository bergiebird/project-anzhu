@icon("res://resources/environment/objectsSmart/interactables/icon_interactable.png")
extends Node2D # Interactable.gd

signal interacted

@export var interaction_enter :String = "Press F to interact"
@export var interacted_with :String = "This is a note."
@export var interaction_exit :String = 'Have left the interaction zone'
var player :Player

func _ready():
	_debug()
	Libraryton.player_reference.connect(func(ref): player = ref)
	interacted.connect(func():_dprint(interacted_with))
	set_process(false)

func _on_area_2d_body_entered(body: Player) -> void:
	set_process(true)
	_dprint(interaction_enter)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('interact'):
		interacted.emit()

func _on_area_2d_body_exited(body: Player) -> void:
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
