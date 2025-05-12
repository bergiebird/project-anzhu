@icon("res://resources/environment/objectsSmart/interactables/icon_interactable.png")
class_name Interactible extends Area2D

var player :Player
@onready var parent = get_parent()
@onready var interaction_enter :String = "Press F to interact with " + self.name
@onready var interacted_with :String = "This is a note from " + self.name
@onready var interaction_exit :String = 'Have left the interaction zone of ' + self.name

func _ready()->void:
	_debug()
	_signaler()
	set_collision_layer_value(8,true)
	set_collision_mask_value(8,true)
	set_process(false)

func _on_body_entered(body :Node2D)->void:
	if body is Player:
		set_process(true)
		_dprint(interaction_enter)

func _process(_delta :float)->void:
	if Input.is_action_just_pressed('interact'):
		parent.observer_null.emit('interacted')

func _on_body_exited(body :Node2D)->void:
	if body is Player:
		set_process(false)
		_dprint(interaction_exit)

func _get_player_reference(ref :Player)->void:
	player = ref
	Libraryton.player_reference.disconnect(_get_player_reference)

func _signaler()->void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	Libraryton.player_reference.connect(_get_player_reference)
	parent.observer_null.connect(func(func_name): Observerton.match_null(self, func_name))

#region DEBUG
@export_group('debug')
@export var debug :bool = false
@export var debug_color :Color = Swatchton.GREEN_FOREST

func _debug() ->void:
	if debug:
		Debuggerton.enable_print(self.name, debug_color)

func _dprint(message :String)->void:
	if debug:
		Debuggerton.dprint(message, debug_color)
#endregion
