extends GoalState #GoalNothing.gd

@export var state_options :Array[String] = ["Idle","Sit","Wander"]
@export var time_options :Array[int] = [6,9,30,12,15,5,4]
var chosen_time :int
var chosen_state :String
var old_chosen_state :String
@onready var timer :Timer = $Timer

func ___ready()->void:
	timer.timeout.connect(_on_timeout)
	time_options = [2]

func ___enter()->void:
	timer.start()
	_on_timeout()

func _on_timeout() -> void:
	if is_active:
		chosen_time = time_options.pick_random()
		chosen_state = state_options.pick_random()
		if chosen_state != old_chosen_state:
			grandparent.publisher_one.emit("change_actions", chosen_state)
		timer.wait_time = chosen_time
		old_chosen_state = chosen_state

func exit()->void:
	timer.stop()

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalGoals.Nothing
