class_name AnimalAnimations extends AnimatedSprite2D #AnimalActions.gd


var action_states :Dictionary = {}
var current_action :ActionState
var verified_action :ActionState
var current_direction :String
@onready var parent :AnzhuBeing = get_parent()

func _ready()->void:
	for child :ActionState in get_children():
		action_states[child.name] = child
		if debug_actions:
			child.self_debug = true
	parent.observer_null.connect(func(func_name): Observerton.match_null(self, func_name))
	parent.observer_one.connect(func(func_name, one :Variant): Observerton.match_one(self, func_name, one))
	parent.observer_two.connect(func(func_name, one :Variant, two :Variant): Observerton.match_two(self, func_name, one, two))

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
			current_action._exit()
		else:
			verified_action._enter()
		play(new_action)
		current_action = verified_action

func transition_part_2()->void:
	verified_action._enter()

func direction_flipped(bol :bool):
	flip_h = bol


#region # DEBUG
@export_group('DEBUG')
@export var debug_actions :bool = false

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_actions = true
#endregion
