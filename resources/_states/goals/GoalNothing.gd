
class_name GoalNothing
extends GoalState

@export var state_options: Array[String] = ["Idle","Sit","Wander"]
@export var time_options: Array[int] = [6,9,30,12,15,5,4]

var chosen_time: int
var chosen_state: String
var old_chosen_state: String

@onready var timer: Timer = $Timer

func ___ready():
	timer.timeout.connect(_on_timeout)

func ___enter():
	_on_timeout()

func _on_timeout():
	if is_active:
		chosen_state = state_options.pick_random()
		match chosen_state:
			"Idle":
				timer.start(time_options.pick_random())
				print('idle')
			"Sit":
				timer.start(time_options.pick_random())
				print('sit')
			"Wander":
				grandparent.publish_event.emit("set_GoTo_node")
				timer.start(time_options.pick_random())
				print('wander')
			"Roll":
				timer.start(time_options.pick_random())
				print('roll')
		if chosen_state != old_chosen_state:
			if grandparent:
				grandparent.publish_event.emit("change_actions", chosen_state)
				old_chosen_state = chosen_state

func ___get_state_value(_parent: StateMachine):
	which_state = _parent.AnimalGoals.Nothing

func reached_target():
	_on_timeout()
