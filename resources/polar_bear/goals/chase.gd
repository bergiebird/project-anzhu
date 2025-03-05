extends ActionState #chase.gd

@export var chase_speed: int = 13
@export var slowed_chase_speed: int = 9

@onready var direction_keys = DIRECTIONS.keys()
const DIRECTIONS :Dictionary = {"NORTH":Vector2(0, -1),"SOUTH":Vector2(0, 1),"EAST":Vector2(1, 0),"WEST":Vector2(-1, 0)}
var current_direction :String = "NORTH"
var current_speed

func enter()->void:
	grandparent.is_stunned = false
	if grandparent.is_injured:
		current_speed = slowed_chase_speed
	else:
		current_speed = chase_speed

func update(delta:float)->void:
	pass

func physics_update(delta :float)->void:
	grandparent.velocity += DIRECTIONS[current_direction] * chase_speed * delta
	if grandparent.velocity.x > 50: grandparent.velocity.x = 50
	if grandparent.velocity.y > 50: grandparent.velocity.y = 50
	if grandparent.velocity.x < -50:grandparent.velocity.x = -50
	if grandparent.velocity.y < -50:grandparent.velocity.y = -50
	grandparent.move_and_slide()

func change_direction()->void:
	move_toward_target(grandparent.player.position)

func move_toward_target(target_position :Vector2)->void:
	var direction_to_target = grandparent.global_position.direction_to(target_position)
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
		if direction_to_target.y > 0:
			current_direction = "SOUTH"
		else:
			current_direction = "NORTH"
