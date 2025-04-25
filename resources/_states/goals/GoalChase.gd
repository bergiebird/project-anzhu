extends ActionState #GoalChase.gd
const THUNK_THRESHOLD :int = 60
const INITIAL_WAIT_TIME :float = 0.1
@export var chase_speed: int = 13
@export var slowed_chase_speed: int = 9
@export var max_speed :int = 70
@export var charge_direction_times :Array[float] = [2.1,2.2,2.3,2.4,2.5,2.6]

var current_direction :String = "NORTH"
var current_speed :int
var wall_thunk_occured :bool = false
var player :Player

@onready var direction_timer :Timer = $DirectionTimer
@onready var wall_thunk_timer :Timer = $WallThunkTimer

func _ready()->void:
	Libraryton.player_reference.connect(func(ref):player=ref)
	direction_timer.timeout.connect(move_toward_target)
	wall_thunk_timer.timeout.connect(func():wall_thunk_occured = false)

func enter()->void:
	direction_timer.wait_time = INITIAL_WAIT_TIME
	direction_timer.start()
	current_speed = chase_speed

func physics_update(delta :float)->void:
	pass

func update(delta :float)->void:
	process_wall_thunk()

func process_wall_thunk()->void:
	if wall_thunk_occured:
		grandparent.velocity = Vector2.ZERO
	elif (abs(grandparent.velocity.x) > THUNK_THRESHOLD or abs(grandparent.velocity.y) > THUNK_THRESHOLD):
		if grandparent.is_on_wall_only():
			wall_thunk_occured = true
			wall_thunk_timer.start()

func move_toward_target(target_position :Vector2 = player.position)->void:
	direction_timer.wait_time = charge_direction_times.pick_random()
	var direction_to_target :int = Directon.get_prevalent_direction(grandparent.global_position.direction_to(target_position))
	print(direction_to_target, "THESE")
	var abs_position_difference :Vector2 = abs(grandparent.player.position - grandparent.global_position)
	if  abs_position_difference.x < 9.3 and abs_position_difference.y < 9.3:
		grandparent.velocity = Vector2.ZERO
	grandparent.velocity_force = abs(grandparent.player.position) * chase_speed

func exit()->void:
	direction_timer.stop()
