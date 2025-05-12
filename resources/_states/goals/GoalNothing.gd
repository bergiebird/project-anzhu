extends GoalState #GoalNothing.gd

@export var state_options :Array[String] = ["Idle","Sit","Wander"]
@export var time_options :Array[int] = [6,9,30,12,15,5,4]
var chosen_time :int
var chosen_state :String
var old_chosen_state :String
@onready var timer :Timer = $Timer

func ___ready()->void:
	Debuggerton.signal_checker([
		timer.timeout.connect(_on_timeout)])

func ___enter()->void:
	timer.start()
	_on_timeout()

func _on_timeout() -> void:
	if goal_is_still_same():
		chosen_time = time_options.pick_random()
		chosen_state = state_options.pick_random()
		if chosen_state != old_chosen_state:
			grandparent.change_actions(chosen_state)
		timer.wait_time = chosen_time
		old_chosen_state = chosen_state

func exit()->void:
	timer.stop()
