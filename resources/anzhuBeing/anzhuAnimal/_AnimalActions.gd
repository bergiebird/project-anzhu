extends StateMachine
class_name AnimalActionsMachine

enum AnimalActions {Idle,Stunned,Sit,Wander,Chase,Roll}


@export var starting_action :AnimalActions = AnimalActions.Idle
var animal_actions: Dictionary[AnimalActions, String] = {
	AnimalActions.Idle:"Idle",
	AnimalActions.Stunned: "Stunned",
	AnimalActions.Sit: "Sit",
	AnimalActions.Wander: "Wander",
	AnimalActions.Chase: "Chase",
	AnimalActions.Roll: "Roll",
}
var actions: Dictionary[AnimalActions, ActionState]
@onready var current_action :AnimalActions = -1


func __ready():
	for child :ActionState in get_children():             # May be redundant as statemachine gets same children
		child.___get_state_value(self)                     # Each state initializes its own AnimalActions key
		actions[child.which_state] = child
	call_deferred("late_ready")

func late_ready():
	parent.publish_event.emit("change_actions", animal_actions[starting_action])

func change_actions(incoming_action):
	if incoming_action is String:
		incoming_action = get_node(incoming_action).which_state
		if incoming_action is not AnimalActions:
			printerr('FAILURE')
	if incoming_action is AnimalActions:
		if current_action != incoming_action:
			current_action = incoming_action
			on_transition(actions[current_action])
			if debug_self:
				print_rich(
					'[color=green]Transitioning to: [color=white]%s[/color][/color]' % animal_actions[incoming_action])
	else:
		_debug()




#region #==========================================================# DEBUG
@export_group('DEBUG')
@export var debug_self: bool = false

func debug()->void:
	print_rich('[color=yellow]Animal Actions Machine debugging enabled . . .[/color]')
	debug_self = true

func _debug():
	print(current_action)

#endregion
