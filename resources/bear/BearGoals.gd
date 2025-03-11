@icon("res://warehouse/_icons/node/icon_transition.png")
class_name AnimalGoalsMachine extends Node #BearGoals.gd

var goal_states :Dictionary = {}
var current_goal :GoalState
var audio :Node2D
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		audio = node_dictionary["AudioManager"]
		for child in get_children():
			if child is State:
				child.grandparent = node_dictionary['parent']
				child.parent = self

func _ready()->void:
	get_goals()

func on_goal_transition(new_goal_name, old_goal=null)->void:
	if goal_states == {}:
		return
	if current_goal != null:
		if new_goal_name == current_goal.name:
			return
	var verify_new_goal :GoalState = goal_states.get(new_goal_name)
	if !verify_new_goal:
		return
	if current_goal:
		current_goal.on_exit()
	current_goal = verify_new_goal
	current_goal.on_enter()


func get_goals()->void:
	for child in get_children():
		if child is GoalState:
			goal_states[child.name] = child
			child.goal_transition.connect(on_goal_transition)
