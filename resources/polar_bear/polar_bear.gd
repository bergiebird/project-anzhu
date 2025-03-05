@icon("res://resources/polar_bear/polar_bear.png")
extends AnzhuCharacter #polar_bear.gd

signal has_died(is_playing_music :bool)

@onready var anim :AnimatedSprite2D = $AnimalActions
@onready var goals :Node = $AnimalGoals
@onready var audio :Node2D = $Audio
@onready var player :Node = get_node('%Player')
var current_speed :int
var is_stunned :bool = false
var is_injured :bool = false

func _ready()->void:
	current_speed = move_speed
	change_goals(AnimalGoals.keys()[starting_goal])

func got_hit()->void:
	is_stunned = true
	is_injured = true
	change_actions("Hit")
	change_goals("Hunt")

func hit_over()->void: change_actions("Chase")

func change_actions(new_action_name :String)->void:
	if new_action_name == AnimalActions.keys()[current_action]: return
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
		_: return
	anim.on_action_transition(new_action_name)

func change_goals(new_goal_name :String)->void:
	if new_goal_name == AnimalGoals.keys()[current_goal]: return
	print(new_goal_name)
	match new_goal_name:
		"Nothing":   current_goal = AnimalGoals.Nothing
		"GetSleep":  current_goal = AnimalGoals.GetSleep
		"FindFood":  current_goal = AnimalGoals.FindFood
		"Hunt":      current_goal = AnimalGoals.Hunt
		_: return
	goals.on_goal_transition(new_goal_name)

func _at_end_of_death_roar()->void:
	has_died.emit(audio.get_is_playing("Hunt"))
	queue_free()

func uninjur()->void: is_injured = false
