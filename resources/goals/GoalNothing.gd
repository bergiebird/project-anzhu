extends GoalState #GoalNothing.gd

@export var state_options :Array[String] = ["Idle","Sit","Wander"]
@export var time_options :Array[int] = [6,9,3,12,15]
@onready var nothing_timer :Timer = $Timer_Nothing

func enter()->void:
	nothing_timer.start()

func _on_timeout() -> void:
	if goal_is_still_same():
		nothing_timer.wait_time = time_options.pick_random()
		action_transition.emit(state_options.pick_random())

func exit()->void:
	nothing_timer.stop()
