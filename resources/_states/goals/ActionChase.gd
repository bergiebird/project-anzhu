extends ActionState
class_name ActionChase

var player :Player
var current_speed

@onready var direction_timer :Timer = $DirectionTimer

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Chase

func ___ready():
	Libraryton.player_reference.connect(func(ref :Player):player=ref)
	direction_timer.timeout.connect(_direction_timed_out)

func ___enter():
	grandparent.publisher_one.emit("set_GoTo_node", player)
	direction_timer.start()
	charge()

func player_spotted():
	if is_active:
		charge()

func player_out_of_sight():
	if is_active:
		current_speed = grandparent.SpeedType.WALK

func _physics_process(_delta: float):
	if is_active:
		grandparent.publisher_one.emit("move_towards_target", current_speed)

func _direction_timed_out():
	grandparent.publisher_one.emit("set_GoTo_node", player)

func ___exit():
	direction_timer.stop()

func reached_target():
	if is_active:
		grandparent.publisher_one.emit("set_GoTo_node", player)

func charge():
	current_speed = grandparent.SpeedType.RUN
	await get_tree().create_timer(10.0).timeout
	current_speed = grandparent.SpeedType.JOG


#region	DEBUG
@export_group('Debug')
@export var debug :bool = false
#endregion
