class_name AnimalAnimations extends AnimatedSprite2D #BearActions.gd
@export_category('DEBUG')
@export var debug_actions :bool = false
@onready var parent :AnzhuCharacter = get_parent()
var action_states :Dictionary = {}
var current_action :ActionState

var verified_action :ActionState
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		for child in get_children():
			child.parent = self
			child.grandparent = node_dictionary['scene_root']
			child.animal_icon = node_dictionary['scene_root'].animal_icon
			if child.name == 'Hit':
				child.hurt_box_node = node_dictionary['HurtBox']
				child.stats_node = node_dictionary['Stats']
			if child.name == 'Dead':
				child.corpse_node = node_dictionary['Corpse']

func _ready()->void:
	for child in get_children():
		if child is ActionState:
			action_states[child.name] = child
			child.action_transition.connect(on_action_transition)
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

func on_action_transition(new_action_name :String, old_action=null)->void:
	if current_action != null and new_action_name == current_action.name:
		return
	verified_action = action_states.get(new_action_name)
	if !verified_action:
		return
	if current_action:
		current_action.on_exit()
	else:
		verified_action.on_enter()
	play(new_action_name)
	current_action = verified_action

func transition_part_2()->void:
	verified_action.on_enter()

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_actions = true
