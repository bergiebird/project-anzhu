extends GoalState #GoalNothing.gd

@export var state_options :Array[String] = ["Idle","Sit","Wander"]
@export var time_options :Array[int] = [6,9,30,12,15,50,45]
@onready var timer :Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func enter()->void:
	timer.start()
	action_transition.emit('Sit') # Starting Option

func _on_timeout() -> void:
	if goal_is_still_same():
		timer.wait_time = time_options.pick_random()
		action_transition.emit(state_options.pick_random())

func exit()->void:
	timer.stop()
