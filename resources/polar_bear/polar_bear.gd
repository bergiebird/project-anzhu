@icon("res://resources/polar_bear/polar_bear.png")
extends AnzhuCharacter #polar_bear.gd

@onready var anim :AnimatedSprite2D = $Actions
@onready var goals :Node = $Goals
@onready var player :Node = get_node('%Player')
var current_speed :int
var is_injured :bool

func _ready()->void:
	current_speed = move_speed
	change_goals(Goals.keys()[starting_goal])

func got_hit()->void:
	change_actions("Hit")

func hit_over()->void:
	change_actions("Chase")

func change_actions(new_action_name :String)->void:
	if new_action_name == Actions.keys()[current_action]: return
	match new_action_name:
		"Idle":   current_action = Actions.Idle
		"Sit":    current_action = Actions.Sit
		"Hit":    current_action = Actions.Hit
		"Wander": current_action = Actions.Wander
		"Chase":  current_action = Actions.Chase
		"Dead":   current_action = Actions.Dead
		"Search": current_action = Actions.Search
		"Charge": current_action = Actions.Charge
		"Sleep":  current_action = Actions.Sleep
		_: return
	anim.on_action_transition(new_action_name)

func change_goals(new_goal_name :String)->void:
	if new_goal_name == Goals.keys()[current_goal]: return
	match new_goal_name:
		"Nothing":   current_goal = Goals.Nothing
		"GetSleep":  current_goal = Goals.GetSleep
		"FindFood":  current_goal = Goals.FindFood
		"Hunt":      current_goal = Goals.Hunt
		_: return
	goals.on_goal_transition(new_goal_name)

func _on_roar_hurt_finished()->void:
	queue_free()
#
#func _on_roar_spotted_finished()->void:
	#update_current_move_speed(-injured_speed_decrease)
	#await get_tree().create_timer(5.0).timeout
	#update_current_move_speed()
#
#func update_current_move_speed(modifying_number :int = 0)->void:
	#if modifying_number != 0:
		#current_speed += modifying_number
		#check_if_is_injured()
		#return
	#if not check_if_is_injured():
		#current_speed = move_speed
#
#func check_if_is_injured()->bool:
	#if is_injured:
		#current_speed -= injured_speed_decrease
		#return true
	#return false
