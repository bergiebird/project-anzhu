extends ActionState #ActionChase.gd
const THUNK_THRESHOLD :int = 60
const PLAYER_DISTANCE_THRESHOLD :float = 9.3
const INITIAL_WAIT_TIME :float = 0.1
@export var chase_speed: int = 13
@export var max_speed :int = 70
@export var direction_times :Array[float] = [2.1,2.2,2.3,2.4,2.5,2.6]

var current_direction :String = "NORTH"
var current_speed :int
var player :Player

@onready var direction_timer :Timer = $DirectionTimer

func ___ready()->void:
	Libraryton.player_reference.connect(func(ref :Player)->void:player=ref)
	direction_timer.timeout.connect(move_toward_target)

func ___enter()->void:
	direction_timer.wait_time = INITIAL_WAIT_TIME
	direction_timer.start()
	current_speed = chase_speed

func move_toward_target(target_position :Vector2 = player.position)->void:
	_direction_to_target(target_position)
	if close_enough_to_player_then_stop_moving():
		return

func _direction_to_target(target_position :Vector2)->void:
	direction_timer.wait_time = direction_times.pick_random()
	grandparent.current_direction = Directon.get_DIRECTION_via_VECTOR(target_position)

func close_enough_to_player_then_stop_moving()->bool:
	var abs_position_difference :Vector2 = abs(grandparent.player.position - grandparent.global_position)
	if abs_position_difference.x < PLAYER_DISTANCE_THRESHOLD and abs_position_difference.y < PLAYER_DISTANCE_THRESHOLD:
		grandparent.velocity = Vector2.ZERO
		return true
	else:
		return false

func exit()->void:
	direction_timer.stop()

func physics_update(_delta :float)->void:pass
func update(_delta :float)->void: pass


###
##	DEBUG
###

@export_group('Debug')
@export var debug :bool = false




































#	process_wall_thunk()

#func process_wall_thunk()->void:
	#if wall_thunk_occured:
		#grandparent.velocity = Vector2.ZERO
	#elif (abs(grandparent.velocity.x) > THUNK_THRESHOLD or abs(grandparent.velocity.y) > THUNK_THRESHOLD):
		#if grandparent.is_on_wall_only():
			#wall_thunk_occured = true
			#wall_thunk_timer.start()

#var wall_thunk_occured :bool = false
#@onready var wall_thunk_timer :Timer = $WallThunkTimer
