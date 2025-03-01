extends Node #idle


func _unprocess()->void:
	set_physics_process(false)
	set_process(false)

func enter()->void:
	pass
