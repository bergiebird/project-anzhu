extends ActionState #hit.gd

func on_enter()->void:
	goal_transition.emit('Hunt')

func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass

func on_exit()->void:
	pass
