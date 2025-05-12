@icon("res://warehouse/icons/node/icon_transition.png")
class_name AnimalGoalsMachine extends Node #AnimalGoals.gd

var goal_states :Dictionary = {}
var current_goal :GoalState
var verified_goal :GoalState
var verified_name :String

func _ready()->void:
	for child :GoalState in get_children():
		goal_states[child.name] = child
		if debug_goals:
			child.self_debug = true

func on_goal_transition(new_goal_name :String)->void:
	if goal_states != {}:
		if current_goal != null:
			if new_goal_name == current_goal.name:
				return
		verified_goal = goal_states.get(new_goal_name)
		if verified_goal:
			if current_goal:
				current_goal._exit()
			else:
				verified_goal._enter()
			current_goal = verified_goal

func transition_part_2()->void:
	verified_goal._enter()

func _match_null(method_name :String):
	if has_method(method_name):
		Callable(self, method_name)


#region # DEBUG
@export_group('DEBUG')
@export var debug_goals :bool = false
func debug()->void:
	pass
#endregion
