@icon("res://resources/goals/goals.png")
extends Node

enum PolarBearGoals {GetSleep,FindFood,FindWater,Nothing,Hunt}
@onready var get_sleep :Node = $GetSleep
@onready var find_food :Node = $FindFood
@onready var find_water :Node = $FindWater
@onready var hunt :Node = $Hunt
@onready var nothing :Node = $Nothing
var current_goal :PolarBearGoals

func _ready()->void:
	unprocess_all()

func process_get_sleep()->void:
	current_goal = PolarBearGoals.GetSleep

func process_find_food()->void:
	current_goal = PolarBearGoals.FindFood

func process_find_water()->void:
	current_goal = PolarBearGoals.FindWater

func process_hunt()->void:
	current_goal = PolarBearGoals.Hunt
	hunt.enter()

func process_nothing()->void:
	current_goal = PolarBearGoals.Nothing
	nothing.enter()


func unprocess_all()->void:
	unprocess_get_sleep()
	unprocess_find_food()
	unprocess_find_water()
	unprocess_hunt()
	unprocess_nothing()

func unprocess_get_sleep()->void:
	get_sleep.set_process(false)
	get_sleep.set_physics_process(false)

func unprocess_find_food()->void:
	find_food.set_process(false)
	find_food.set_physics_process(false)

func unprocess_find_water()->void:
	find_water.set_process(false)
	find_water.set_physics_process(false)

func unprocess_hunt()->void:
	hunt.set_process(false)
	hunt.set_physics_process(false)

func unprocess_nothing()->void:
	nothing.set_process(false)
	nothing.set_physics_process(false)
