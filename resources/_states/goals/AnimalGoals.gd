extends StateMachine
class_name AnimalGoalsMachine

enum AnimalGoals {Nothing,Hunt}
@export var starting_goal :AnimalGoals = AnimalGoals.Nothing
@onready var current_goal :AnimalGoals = -1


func __ready():
	change_goals(starting_goal)

func change_goals(incoming_goal):
	if incoming_goal is String:
		incoming_goal = get_node(incoming_goal).which_state
	if incoming_goal is AnimalGoals:
		if current_goal != incoming_goal:
			current_goal = incoming_goal
			on_transition(states[current_goal])




#region # DEBUG
@export_group('DEBUG')
@export var debug_goals: bool = false
func debug()->void:
	pass
#endregion
