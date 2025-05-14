class_name AnimalActionsMachine extends StateMachine

enum AnimalActions {Nothing,Hunt}
@export var starting_action :AnimalActions = AnimalActions.Nothing
@onready var current_action :AnimalActions = -1
var actions :Dictionary[AnimalActions, ActionState]

func __ready()->void:
	for child:ActionState in get_children():             # May be redundant as statemachine gets same children
		child.___get_state_value(self)                    # Each state initializes its own AnimalActions key
		actions[child.which_action] = child               # Put together dictionary
	change_actions(starting_action)                      # Run the first action because current_action should be null


func change_actions(incoming_action):
	if incoming_action is String:                               # Makes it easy for other nodes to call this without knowing the enum
		incoming_action = get_node(incoming_action).which_action
	if incoming_action is AnimalActions:                        # Was highly type unsafe up to this point, this should lock in the type
		if current_action != incoming_action:                    # Check if redundant, we don't execute redundancies
			current_action = incoming_action
			on_transition(actions[current_action])

func change_actions(new_action_name :String):
	if new_action_name != AnimalActions.keys()[current_action]:
		match new_action_name:
			"Idle":   current_action = AnimalActions.Idle
			"Sit":    current_action = AnimalActions.Sit
			"Hit":    current_action = AnimalActions.Hit
			"Wander": current_action = AnimalActions.Wander
			"Chase":  current_action = AnimalActions.Chase
			"Dead":   current_action = AnimalActions.Dead
			"Search": current_action = AnimalActions.Search
			"Charge": current_action = AnimalActions.Charge
			"Sleep":  current_action = AnimalActions.Sleep
			"Graze":  current_action = AnimalActions.Graze
			"Dash":   current_action = AnimalActions.Dash
			_:        return
		anim.on_action_transition(new_action_name)
		old_action_name = new_action_name

func _ready()->void:
	for child :ActionState in get_children():
		action_states[child.name] = child
		if debug_actions: child.self_debug = true


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
