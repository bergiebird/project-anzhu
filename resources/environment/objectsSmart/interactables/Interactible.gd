@icon("res://resources/environment/objectsSmart/interactables/icon_interactable.png")

class_name Interactible
extends Area2D

signal interacted
signal player_entered_the_space(bool)


func _ready() -> void:
	ready.connect(_debug)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if debug: interacted.connect(debug_interacted)
	set_collision_layer_value(8, true)
	set_collision_mask_value(8, true)
	set_process(false)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		set_process(true)
		player_entered_the_space.emit(true)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('interact'):
		interacted.emit()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		set_process(false)
		player_entered_the_space.emit(false)



#region #===========================================================================================# Debug
@export_group('debug')
@export var debug: bool = false
@export var debug_color: Color = Lib.Palette.GREEN_FOREST
@onready var interaction_enter: String = "Press F to interact with " + self.name
@onready var interacted_with: String = "This is a note from " + self.name
@onready var interaction_exit: String = 'Have left the interaction zone of ' + self.name
@onready var parent = get_parent()

func _debug() ->void:
	if debug:
		pass

func _dprint(message: String)->void:
		if debug:
			Dbgr.dprint(message, debug_color)

func debug_interacted():
	if debug:
		_dprint('interaction occured at ' + parent.name)
#endregion
