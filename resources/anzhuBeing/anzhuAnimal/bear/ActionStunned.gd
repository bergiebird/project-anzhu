class_name ActionStunned extends ActionState

var after_state :String
@onready var timer :Timer = $StunnedTimer

func start_stun(new_stun_time :float, stored_state :String):
	after_state = stored_state
	grandparent.publisher_one.emit("change_actions", "Stunned")
	timer.wait_time = new_stun_time
	timer.start()

func _physics_process(_delta: float) -> void:
	grandparent.velocity_force *= 0.991

func stun_over():
	await timer.timeout
	grandparent.publisher_one.emit("change_actions", after_state)


func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Stunned
