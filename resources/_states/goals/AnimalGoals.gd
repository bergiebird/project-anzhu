@icon("res://warehouse/icons/node/icon_transition.png")
class_name AnimalGoalsMachine extends Node #AnimalGoals.gd

var goal_states :Dictionary = {}
var current_goal :GoalState
var audio :Node2D
var anim :AnimatedSprite2D
var verified_goal :GoalState
var verified_name :String
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		audio = node_dictionary["AudioManager"]
		anim = node_dictionary['Animations']
		for child in get_children():
			if child is State:
				child.animal_icon = node_dictionary['scene_root'].animal_icon
				child.grandparent = node_dictionary['scene_root']
				child.parent = self

func _ready()->void:
	get_goals()

func on_goal_transition(new_goal_name, old_goal=null)->void:
	if goal_states == {}:
		return
	if current_goal != null:
		if new_goal_name == current_goal.name:
			return
	verified_goal = goal_states.get(new_goal_name)
	if !verified_goal:
		return
	if current_goal:
		current_goal.on_exit()
	else:
		verified_goal.on_enter()
	current_goal = verified_goal

func transition_part_2()->void:
	verified_goal.on_enter()

func get_goals()->void:
	for child in get_children():
		if child is GoalState:
			goal_states[child.name] = child
			if debug_goals:
				child.self_debug = true


###
## DEBUG
###
@export_group('DEBUG')
@export var debug_goals :bool = false
func debug()->void:
	pass
