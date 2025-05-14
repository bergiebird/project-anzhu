class_name AnimalGoalsMachine extends StateMachine

enum AnimalGoals {Nothing,Hunt}
@export var starting_goal :AnimalGoals = AnimalGoals.Nothing
@onready var current_goal :AnimalGoals = -1
var goals :Dictionary[AnimalGoals,GoalState]

func __ready()->void:
	change_goals(starting_goal)                          # Run the first goal because current_goal should be null


func change_goals(incoming_goal)->void:
	if incoming_goal is String:                           # Makes it easy for other nodes to call this without knowing the enum
		incoming_goal = get_node(incoming_goal).which_goal
	if incoming_goal is AnimalGoals:                      # Was highly type unsafe up to this point, this should lock in the type
		if current_goal != incoming_goal:                  # Check if redundant, we don't execute redundancies
			current_goal = incoming_goal
			on_transition(goals[current_goal])

























#region # DEBUG
@export_group('DEBUG')
@export var debug_goals :bool = false
func debug()->void:
	pass
#endregion
