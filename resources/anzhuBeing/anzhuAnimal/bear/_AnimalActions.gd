class_name AnimalActionsMachine extends StateMachine

enum AnimalActions {Idle, Sit, Wander, Hit, Dead, Chase}
@export var starting_action :AnimalActions = AnimalActions.Idle
@onready var current_action :AnimalActions = -1
var actions :Dictionary[AnimalActions, ActionState]
func __ready()->void:
	for child:ActionState in get_children():             # May be redundant as statemachine gets same children
		child.___get_state_value(self)                    # Each state initializes its own AnimalActions key
		actions[child.which_state] = child                # Put together dictionary
	parent.publisher_one.emit("change_actions", starting_action)

func change_actions(incoming_action):
	if incoming_action is String:                               # The simple argument
		if incoming_action == "has_died":
			pass
		incoming_action = get_node(incoming_action).which_state  # Translate String to AnimalActions
	if incoming_action is AnimalActions:                        # Ensures typesafety
		if current_action != incoming_action:                    # Check if redundant, we don't execute redundancies
			current_action = incoming_action                      # Set this for redundancy checking
			on_transition(actions[current_action])                # Call super class's method

	else:                                                       # Catches unsafe arguments
		_debug()



#region	DEBUG
@export_group('DEBUG')
@export var debug_self :bool = false

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_self = true

func _debug():
	pass

#endregion
