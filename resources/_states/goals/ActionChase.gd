extends ActionState
class_name ActionChase

@export var sprint_time: float = 5.0
var player :Player
var current_speed: String
@onready var sfx_chase: AudioStreamPlayer2D = $Sfx_Chase
@onready var direction_timer: Timer = $DirectionTimer
@onready var charge_timer: Timer = $ChargeTimer

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Chase

func ___ready():
	Sgnl.player_reference.connect(acquire_player)
	direction_timer.timeout.connect(reached_target)
	charge_timer.timeout.connect(___end_charge)

func acquire_player(ref :Player):
	player=ref
	Sgnl.player_reference.disconnect(acquire_player)

func ___enter():
	if not is_active:
		return
	if not sfx_chase.is_playing():
		sfx_chase.play()
	grandparent.publish_event.emit("set_GoTo_node", player)
	direction_timer.start()
	___start_charge()

func player_spotted():if is_active:
	___start_charge()

func player_out_of_sight(): if is_active:
	current_speed = "Walk"

func reached_target(): if is_active:
	grandparent.publish_event.emit("set_GoTo_node", player)

func _physics_process(_delta: float):
	grandparent.publish_event.emit("move_towards_target", current_speed)

func ___exit():
	direction_timer.stop()
	charge_timer.stop()
	current_speed = "Jog"

func ___start_charge(): if is_active:
	charge_timer.start()
	current_speed = "Run"

func ___end_charge():
	current_speed = "Jog"

func strike_target(_blah: Attack):
	await get_tree().create_timer(0.32).timeout
	charge_timer.stop()
	current_speed = "Jog"

func was_struck():
	charge_timer.wait_time += 0.1
