extends ActionState #ActionWander.gd
@export var movement_speed: int = 10
@export var slowed_movement_speed: int = 7
@onready var direction_keys = DIRECTIONS.keys()
@onready var timer = $Timer

const DIRECTIONS :Dictionary = {"NORTH":Vector2(0, -1),"SOUTH":Vector2(0, 1),"EAST":Vector2(1, 0),"WEST":Vector2(-1, 0)}
var current_direction :String = "NORTH"

func _ready() -> void:
	timer.timeout.connect(change_direction)

func enter()->void:
	timer.start()

func physics_update(delta :float)->void:
	if grandparent.is_stunned:
		return
	grandparent.position += DIRECTIONS[current_direction] * movement_speed * delta

func change_direction()->void:
	current_direction = direction_keys[randi() % direction_keys.size()]

func move_toward_target(target_position :Vector2)->void:
	var direction_to_target = grandparent.global_position.direction_to(target_position)
	if abs(direction_to_target.x) > abs(direction_to_target.y):
		if direction_to_target.x > 0:
			parent.set_flip_h(false)
			current_direction = "EAST"
		else:
			parent.set_flip_h(true)
			current_direction = "WEST"
	else:
		if direction_to_target.y > 0:
			current_direction = "SOUTH"
		else:
			current_direction = "NORTH"

func update(delta:float)->void:
	pass

func exit()->void:
	timer.stop()
