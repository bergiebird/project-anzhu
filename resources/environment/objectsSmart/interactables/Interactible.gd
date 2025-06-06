@icon("res://resources/environment/objectsSmart/interactables/icon_interactable.png")
extends Area2D
class_name Interactible

enum Interact {
	OnButtonPress,
	OnCollision,
	OnSight,
	OnClick,
}

@export var primary_interactible_state :Interact
@export var secondary_interactible_state : Interact

func _ready():
	_signaler()
	set_collision_layer_value(8,true)
	set_collision_mask_value(8,true)
	set_process(false)

func _on_body_entered(body :Node2D):
	if body is Player:
		set_process(true)
		parent.publish_event.emit('player_entered_the_space')

func _process(_delta :float):
	if Input.is_action_just_pressed('interact'):
		parent.publish_event.emit('interacted')

func _on_body_exited(body :Node2D):
	if body is Player:
		set_process(false)
		parent.publish_event.emit('player_left_the_space')

func _signaler():
	ready.connect(_debug)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

@export_group('debug')
#region
@export var debug :bool = false
@export var debug_color :Color =L.Palette.GREEN_FOREST
@onready var interaction_enter :String = "Press F to interact with " + self.name
@onready var interacted_with :String = "This is a note from " + self.name
@onready var interaction_exit :String = 'Have left the interaction zone of ' + self.name
@onready var parent = get_parent()

func _debug() ->void:
	if debug:
		pass

func _dprint(message :String)->void:
		if debug:
			Debuggerton.dprint(message, debug_color)

func interacted():
	if debug:
		_dprint('interaction occured at ' + parent.name)






#endregion
