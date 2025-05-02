class_name AnimalAnimations extends AnimatedSprite2D #AnimalActions.gd

@onready var parent :AnzhuBeing = get_parent()

var action_states :Dictionary = {}
var current_action :ActionState
var verified_action :ActionState
var current_direction :String
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		for child :State in get_children():
			child.collect_dictionary(node_dictionary, self)

func _ready()->void:
	for child :ActionState in get_children():
		action_states[child.name] = child
		if debug_actions:
			child.self_debug = true
	Debuggerton.signal_checker([
		parent.direction_changed_named.connect(change_direction)])

func being_process(delta :float)->void:
	if current_action:
		current_action.update(delta)

func being_physics_process(delta :float)->void:
	if not parent.is_stunned:
		if current_action:
			current_action.physics_update(delta)

func on_action_transition(new_action :String, _old_action :String="")->void:
	if current_action != null and new_action == current_action.name:
		return
	verified_action = action_states.get(new_action)
	if verified_action:
		if current_action:
			current_action.on_exit()
		else:
			verified_action.on_enter()
		play(new_action)
		current_action = verified_action

func transition_part_2()->void:
	verified_action.on_enter()

func change_direction(new_direction :String=Directon.change_direction())->String:
	match new_direction:
		"_NORTH":  flip_h = false
		"_SOUTH":  flip_h = false
		"_EAST":   flip_h = false
		"_WEST":   flip_h = true
	current_direction = new_direction
	return current_direction



###
## DEBUG
###
@export_group('DEBUG')
@export var debug_actions :bool = false

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_actions = true
