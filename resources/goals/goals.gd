@icon("res://resources/goals/goals.png")
extends Node #goals.gd

var goal_states :Dictionary = {}
var current_goal :GoalState

func _ready()->void:
	for child in get_children():
		if child is GoalState:
			goal_states[child.name] = child
			child.goal_transition.connect(on_goal_transition)

func on_goal_transition(new_goal_name, old_goal=null)->void:
	if current_goal != null:
		if new_goal_name == current_goal.name:
			return
	var verify_new_goal :GoalState = goal_states.get(new_goal_name)
	if !verify_new_goal:
		return
	if current_goal: current_goal.exit()
	current_goal = verify_new_goal
	current_goal.enter()
