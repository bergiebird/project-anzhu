extends AnimatedSprite2D #BearActions.gd

var action_states :Dictionary = {}
var current_action :ActionState

@export var debug_all :bool = false
@onready var parent :AnzhuCharacter = get_parent()
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		for child in get_children():
			child.parent = self
			child.grandparent = node_dictionary['parent']

func _ready()->void:
	for child in get_children():
		if child is ActionState:
			action_states[child.name] = child
			child.action_transition.connect(on_action_transition)
			if debug_all:
				child.self_debug = true

func _process(delta :float)->void:
	if current_action:
		current_action.update(delta)

func _physics_process(delta:float)->void:
	if parent.is_stunned:
		return
	if current_action:
		current_action.physics_update(delta)

func on_action_transition(new_action_name :String, old_action = null)->void:
	if current_action != null:
		if new_action_name == current_action.name:
			return
	var verify_new_action :ActionState = action_states.get(new_action_name)
	if !verify_new_action: return
	if current_action: current_action.on_exit()
	current_action = verify_new_action
	current_action.on_enter()
	play(new_action_name)
