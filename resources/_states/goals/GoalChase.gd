extends ActionState #GoalChase.gd

@export var chase_speed: int = 13
@export var slowed_chase_speed: int = 9
@export var max_speed :int = 70

var current_direction :String = "NORTH"
var current_speed :int
var wall_thunk_occured :bool = false
var player :Player

@onready var direction_timer :Timer = $DirectionTimer
@onready var wall_thunk_timer :Timer = $WallThunkTimer

func _ready()->void:
	Libraryton.player_reference.connect(func(ref):player=ref)
	direction_timer.timeout.connect(func(): move_toward_target(player.position))
	wall_thunk_timer.timeout.connect(func():wall_thunk_occured = false)

func enter()->void:
	direction_timer.start()
	current_speed = chase_speed

func physics_update(delta :float)->void:
	#grandparent.velocity += Directon.get_vectors() * chase_speed * delta
	grandparent.velocity.x = clamp(grandparent.velocity.x, -max_speed, max_speed)
	grandparent.velocity.y = clamp(grandparent.velocity.y, -max_speed, max_speed)

func update(delta :float)->void:
	process_wall_thunk()

func process_wall_thunk()->void:
	if wall_thunk_occured:
		grandparent.velocity = Vector2.ZERO
	elif (abs(grandparent.velocity.x)>60 or abs(grandparent.velocity.y)>60):
		if grandparent.is_on_wall_only():
			wall_thunk_occured = true
			wall_thunk_timer.start()

func move_toward_target(target_position :Vector2)->void:
	var direction_to_target :Vector2 = grandparent.global_position.direction_to(target_position)
	print('DIRECTION TO TARGET: ', direction_to_target)
	if abs(direction_to_target.x) > abs(direction_to_target.y):
		grandparent.velocity.y = 0
		if direction_to_target.x > 0:
			parent.set_flip_h(false)
		else:
			parent.set_flip_h(true)
	else:
		grandparent.velocity.x = 0
	current_direction = Directon.get_current_direction()
	var abs_position_difference :Vector2 = abs(grandparent.player.position - grandparent.global_position)
	if  abs_position_difference.x < 9.3 and abs_position_difference.y < 9.3:
		grandparent.velocity = Vector2.ZERO

func exit()->void:
	direction_timer.stop()
