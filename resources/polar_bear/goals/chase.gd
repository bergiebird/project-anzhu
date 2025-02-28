extends Node #chase.gd

@onready var parent :Node = get_parent()


func start_action()->void:
	set_physics_process(true)



func end_action()->void:
	set_physics_process(false)
