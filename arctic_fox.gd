@icon("res://resources/arctic_fox/arctic_fox.png")
extends StaticBody2D

@export_group('speed')
@export var walk :int = 10
@export var run :int = 60
@export_group('detection')
@export var sight_radius :int = 100
@export var smell_radius :int = 1000
@export_group('health')
@export var starting_health :int = 2
@export var flee_health :int = 1
@export_group('food')
@export var starting_food :int = 10
@export var food_depletion_rate :int = 1
@export_group('water')
@export var starting_water :int = 10
@export var water_depletion_rate :int = 1
@export_group('wander')
@export var potential_to_wander :int = 5
@export var time_until_new_position :int = 5
@export_group('current action')
@export var current_state = Enumerton.AnimalState.IDLE
@export var is_alert :bool = false
