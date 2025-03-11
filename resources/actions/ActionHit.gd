extends ActionState #ActionHit.gd

@onready var hit_timer :Timer = $"Timer_Hit"

func enter()->void:
	hit_timer.start()
	goal_transition.emit('Hunt')

func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass

func exit()->void:
	hit_timer.stop()
