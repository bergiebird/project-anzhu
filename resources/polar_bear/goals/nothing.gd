extends GoalState #Nothing

@export var state_options :Array[Node] = []
@export var time_options :Array[int] = [5,9,2,1,10,15]
@onready var nothing_timer :Node = %TimerManager

func on_enter()->void:
	action_transition.emit(state_options.pick_random().name)

func _on_timeout() -> void:
	if parent.current_goal != self:
		return
	var new_name = state_options.pick_random().name
	nothing_timer.change_timers_time(self.name, time_options.pick_random())
	action_transition.emit(new_name)
