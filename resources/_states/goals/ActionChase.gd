extends ActionState
class_name ActionChase

signal move_towards_target(_current_speed: Lib.Beings.Speed)

@export var sprint_time: float = 5.0

var current_speed: Lib.Beings.Speed

@onready var sfx_chase: AudioStreamPlayer2D = $Sfx_Chase
@onready var direction_timer: Timer = $DirectionTimer
@onready var charge_timer: Timer = $ChargeTimer

func ___get_state_value(_parent: StateMachine):
	which_state = _parent.AnimalActions.Chase


func ___enter():
	if not is_active:
		return
	if not sfx_chase.is_playing():
		sfx_chase.play()
	grandparent.publish_event.emit("set_GoTo_node", grandparent.player)
	direction_timer.start()
	___start_charge()


func player_spotted():
	if is_active:
		___start_charge()


func player_out_of_sight():
	if is_active:
		current_speed = Lib.Beings.Speed.WALK

func reached_target():
	if is_active:
		grandparent.publish_event.emit("set_GoTo_node", grandparent.player)

func _physics_process(_delta: float):
	move_towards_target.emit(current_speed)
#	grandparent.publish_event.emit("move_towards_target", current_speed)

func ___exit():
	direction_timer.stop()
	charge_timer.stop()
	current_speed = Lib.Beings.Speed.JOG

func ___start_charge():
	if is_active:
		charge_timer.start()
		current_speed = Lib.Beings.Speed.RUN

func ___end_charge():
	current_speed = Lib.Beings.Speed.JOG

func strike_target(_blah: Attack):
	await get_tree().create_timer(0.32).timeout
	charge_timer.stop()
	current_speed = Lib.Beings.Speed.JOG

func was_struck():
	charge_timer.wait_time += 0.1
