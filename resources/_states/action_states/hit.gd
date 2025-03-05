extends ActionState #hit.gd

func enter()->void:
	goal_transition.emit('Hunt')

func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass

func exit()->void:
	pass
