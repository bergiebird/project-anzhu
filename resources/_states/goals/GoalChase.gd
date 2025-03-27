extends ActionState #GoalChase.gd

@onready var timer :Timer = $Timer
@export var chase_speed: int = 13
@export var slowed_chase_speed: int = 9
@export var max_speed :int = 70

@onready var direction_keys = DIRECTIONS.keys()
const DIRECTIONS :Dictionary = {
	"NORTH":Vector2(0, -1),"SOUTH":Vector2(0, 1),
	"EAST": Vector2(1, 0),"WEST":  Vector2(-1, 0)}
var current_direction :String = "NORTH"
var current_speed :int

func _ready() -> void:
	timer.timeout.connect(change_direction)

func enter()->void:
	timer.start()
	current_speed = chase_speed

func physics_update(delta :float)->void:
	grandparent.velocity += DIRECTIONS[current_direction] * chase_speed * delta
	if grandparent.velocity.x > max_speed:  grandparent.velocity.x = max_speed
	if grandparent.velocity.y > max_speed:  grandparent.velocity.y = max_speed
	if grandparent.velocity.x < -max_speed: grandparent.velocity.x = -max_speed
	if grandparent.velocity.y < -max_speed: grandparent.velocity.y = -max_speed
func update(delta :float)->void:return

func change_direction()->void:
	move_toward_target(grandparent.player.position)

func move_toward_target(target_position :Vector2)->void:
	var direction_to_target :Vector2 = grandparent.global_position.direction_to(target_position)
	if abs(direction_to_target.x) > abs(direction_to_target.y):
		grandparent.velocity.y = 0
		if direction_to_target.x > 0:
			parent.set_flip_h(false)
			current_direction = "EAST"
		else:
			parent.set_flip_h(true)
			current_direction = "WEST"
	else:
		grandparent.velocity.x = 0
		if direction_to_target.y > 0: current_direction = "SOUTH"
		else:                         current_direction = "NORTH"
	var absolute_position_differernce :Vector2 = abs(grandparent.player.position - grandparent.global_position)
	if  absolute_position_differernce.x < 9.3 and absolute_position_differernce.y < 9.3:
		grandparent.velocity = Vector2.ZERO
		printt(grandparent.player.position - grandparent.global_position)

func exit()->void:
	timer.stop()
