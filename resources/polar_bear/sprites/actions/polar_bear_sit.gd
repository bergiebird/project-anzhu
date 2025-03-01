extends Node #polar_bear_sit.gd

func _unprocess()->void:
	set_physics_process(false)
	set_process(false)

func enter()->void:
	pass
