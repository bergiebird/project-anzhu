@icon("res://resources/polar_bear/polar_bear.png")
extends StaticBody2D
enum PolarBearGoals {GetSleep,FindFood,FindWater,Nothing,Hunt}
enum PolarBearActions {Idle,Sit,Hit,Search,Chase}

@export var starting_health :int = 10
@export var starting_goal :PolarBearGoals = 3
@onready var anim :AnimatedSprite2D = $PolarBearSprite
@onready var goals :Node = %Goals
@onready var player :Node = get_node('%Player')
@onready var current_action :PolarBearActions
@onready var current_goal :PolarBearGoals

func _ready()->void:
	change_goals(PolarBearGoals.keys()[starting_goal])
func got_hit()->void:
	change_actions("Hit")
func hit_over()->void:
	change_actions("Chase")
func incoming_action_request(new_action_name :String)->void:
	change_actions(new_action_name)
func incoming_goals_request(new_goal_name :String)->void:
	change_goals(new_goal_name)

func change_actions(new_action_name :String)->void:
	if new_action_name == PolarBearGoals.keys()[current_action]:
		return
	match new_action_name:
		"Idle":
			current_action = PolarBearActions.Idle
			anim.process_idle()
		"Sit":
			current_action = PolarBearActions.Sit
			anim.process_sit()
		"Hit":
			current_action = PolarBearActions.Hit
			anim.process_hit()
		"Search":
			current_action = PolarBearActions.Search
			anim.process_search()
		"Chase":
			current_action = PolarBearActions.Chase
			anim.process_chase()
		_:
			print_debug('invalid polar_bear action', new_action_name)
			return

func change_goals(new_goal_name :String)->void:
	if new_goal_name == PolarBearGoals.keys()[current_goal]:
		return
	match new_goal_name:
		"Nothing":
			current_goal = PolarBearGoals.Nothing
			goals.process_nothing()
		"GetSleep":
			current_goal = PolarBearGoals.GetSleep
			goals.process_get_sleep()
		"FindFood":
			current_goal = PolarBearGoals.FindFood
			goals.process_find_food()
		"FindWater":
			current_goal = PolarBearGoals.FindWater
			goals.process_find_water()
		"Hunt":
			current_goal = PolarBearGoals.Hunt
			goals.process_hunt()
		_:
			print_debug('invalid polar_bear goal', new_goal_name)
