class_name ActionChase extends ActionState

var player :Player
@onready var direction_timer :Timer = $DirectionTimer

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Chase

func ___ready()->void:
	Libraryton.player_reference.connect(func(ref :Player)->void:player=ref)

func ___enter()->void:
	direction_timer.timeout.connect(move_toward_target)
	direction_timer.wait_time =  0.1
	direction_timer.start()

func move_toward_target(target_position :Vector2 = player.position)->void:
	direction_timer.wait_time = Libraryton.rng.randf_range(2.0,2.5)
	grandparent.current_direction = Directon.get_DIRECTION_via_VECTOR(target_position)
	var abs_position_difference :Vector2 = abs(grandparent.player.position - grandparent.global_position)
	if abs_position_difference.x < 9.3 and abs_position_difference.y < 9.3:
		grandparent.velocity = Vector2.ZERO

func ___exit()->void:
	direction_timer.timeout.disconnect(move_toward_target)
	direction_timer.stop()


#region	DEBUG

@export_group('Debug')
@export var debug :bool = false
#endregion
