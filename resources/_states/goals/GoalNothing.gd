class_name GoalNothing extends GoalState

@export var state_options :Array[String] = ["Idle","Sit","Wander"]
@export var time_options :Array[int] = [6,9,30,12,15,5,4]
var chosen_time :int
var chosen_state :String
var old_chosen_state :String
@onready var timer :Timer = $Timer

func ___ready()->void:
	timer.timeout.connect(_on_timeout)

func ___enter()->void:
	_on_timeout()

func _on_timeout() -> void:
	if is_active:
		chosen_state = state_options.pick_random()
		match chosen_state:
			"Idle":
				timer.wait_time = time_options.pick_random()
				timer.start()
			"Sit":
				timer.wait_time = time_options.pick_random()
				timer.start()
			"Wander":
				grandparent.publisher_null.emit("set_new_GoTo_location")
			"Roll":
				timer.wait_time = time_options.pick_random()
				timer.start()
		print(chosen_state)
		if chosen_state != old_chosen_state:
			grandparent.publisher_one.emit("change_actions", chosen_state)
			old_chosen_state = chosen_state

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalGoals.Nothing

func reached_target():
	_on_timeout()
