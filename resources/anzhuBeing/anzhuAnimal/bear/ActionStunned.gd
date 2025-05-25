extends ActionState
class_name ActionStunned

var _stored_state :String
var stun_time :float = 0.1
@export var stun_time_modifier :float = 0.48
@export var remove_from_stun_time_modifier :float = 0.016
@onready var timer :Timer = $StunnedTimer

func ___ready():
	timer.wait_time = stun_time
	timer.timeout.connect(stun_over)

func was_struck():
	timer.wait_time += stun_time_modifier
	stun_time_modifier -= remove_from_stun_time_modifier

func start_stun( stored_state :String):
	_stored_state = stored_state
	grandparent.publisher_one.emit("change_actions", "Stunned")
	timer.start()

func _physics_process(_delta: float) -> void:
	grandparent.velocity_force *= 0.9915

func stun_over():
	await timer.timeout
	grandparent.publisher_one.emit("change_actions", _stored_state)


func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Stunned
