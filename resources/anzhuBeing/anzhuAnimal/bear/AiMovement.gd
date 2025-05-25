@icon('res://warehouse/icons/node/icon_brain.png')
extends Node
class_name AIMovement

@onready var parent: AnzhuBeing = get_parent()

var target_position: Vector2 = Vector2.ZERO

func stop_moving():
	parent.velocity_force = Vector2.ZERO
	parent.reset_velocities(true)
	parent.publisher_null.emit("movement_stopped")

func _get_cardinal_direction(direction_vector: Vector2) -> Vector2:
	if direction_vector == Vector2.ZERO:
		return Vector2.ZERO
	var abs_x = abs(direction_vector.x)
	var abs_y = abs(direction_vector.y)
	if abs_y > abs_x:
		if direction_vector.y < 0:
				parent.current_direction = parent.PersonalDirection.NORTH
				return Vector2.UP
		else:
				parent.current_direction = parent.PersonalDirection.SOUTH
				return Vector2.DOWN
	else:
		if direction_vector.x > 0:
				parent.current_direction = parent.PersonalDirection.EAST
				return Vector2.RIGHT
		else:
				parent.current_direction = parent.PersonalDirection.WEST
				return Vector2.LEFT

func new_target_position(incoming_target:Vector2):
	target_position = incoming_target

func move_towards_target(speed_type):
	if target_position != Vector2.ZERO:
		parent.velocity_force = _get_cardinal_direction(target_position - parent.global_position) * float(parent.speed_types[speed_type])
