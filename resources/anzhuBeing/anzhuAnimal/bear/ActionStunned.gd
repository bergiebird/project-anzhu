extends ActionState
class_name ActionStunned


@export var DECELERATION: float = 0.97
@export var stun_time_modifier: float = 0.50
@export var REMOVE_FROM_STUN_TIME_MODIFIER: float = 0.02
@export var DELERATION_ON_ICE: float = 0.9875

var stun_time: float = 0.1

@onready var timer: Timer = $StunnedTimer

func ___ready():
	timer.wait_time = stun_time
	timer.timeout.connect(func(): grandparent.publish_event.emit("change_actions","Chase"))

func ___enter():
	grandparent.set_stun_state(true)
	#grandparent.publish_event.emit("set_stun_state", true)

func was_struck():
	stun_time_modifier -= REMOVE_FROM_STUN_TIME_MODIFIER
	timer.wait_time += stun_time_modifier
	grandparent.publish_event.emit("change_actions", "Stunned")
	timer.start(timer.wait_time + 0.66 if grandparent.is_on_ice else 0.0)

func _physics_process(delta: float):
	if grandparent.is_on_ice:
		grandparent.velocity_force *= delta + DELERATION_ON_ICE
	else:
		grandparent.velocity_force *= delta + DECELERATION

func ___get_state_value(_parent: StateMachine):
	which_state = _parent.AnimalActions.Stunned

func ___exit():
	grandparent.set_stun_state(false)


# ISSUES:
"""


"""
