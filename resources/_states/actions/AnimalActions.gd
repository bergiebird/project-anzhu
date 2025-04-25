class_name AnimalAnimations extends AnimatedSprite2D #AnimalActions.gd

@onready var parent :AnzhuBeing = get_parent()
var action_states :Dictionary = {}
var current_action :ActionState
var verified_action :ActionState
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		for child in get_children():
			child.collect_dictionary(node_dictionary, self)

func _ready()->void:
	for child in get_children():
		if child is ActionState:
			action_states[child.name] = child
			if debug_actions:
				child.self_debug = true

func _process(delta :float)->void:
	if current_action:
		current_action.update(delta)

func _physics_process(delta :float)->void:
	if parent.is_stunned:
		return
	if current_action:
		current_action.physics_update(delta)

func on_action_transition(new_action :String, old_action :String="")->void:
	if current_action != null and new_action == current_action.name:
		return
	verified_action = action_states.get(new_action)
	if !verified_action:
		return
	if current_action:
		current_action.on_exit()
	else:
		verified_action.on_enter()
	play(new_action)
	current_action = verified_action

func transition_part_2()->void:
	verified_action.on_enter()




###
## DEBUG
###
@export_group('DEBUG')
@export var debug_actions :bool = false

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_actions = true
