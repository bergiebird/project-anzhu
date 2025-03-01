extends Node #search.gd
signal is_walking()
@export var movement_speed: int = 10
@export var slowed_movement_speed: int = 7
@onready var anim :AnimatedSprite2D = get_parent()
@onready var moveable_body: StaticBody2D = get_parent().get_parent()
@onready var direction_keys = DIRECTIONS.keys()
const DIRECTIONS :Dictionary = {"NORTH":Vector2(0, -1),"SOUTH":Vector2(0, 1),"EAST":Vector2(1, 0),"WEST":Vector2(-1, 0)}
var current_direction :String = "NORTH"
var is_stunned :bool = false

func _physics_process(delta :float)->void:
	if is_stunned:
		return
	moveable_body.position += DIRECTIONS[current_direction] * movement_speed * delta
	is_walking.emit()

func change_direction()->void:
	current_direction = direction_keys[randi() % direction_keys.size()]

func move_toward_target(target_position :Vector2)->void:
	var direction_to_target = moveable_body.global_position.direction_to(target_position)
	if abs(direction_to_target.x) > abs(direction_to_target.y):
		if direction_to_target.x > 0:
			anim.set_flip_h(false)
			current_direction = "EAST"
		else:
			anim.set_flip_h(true)
			current_direction = "WEST"
	else:
		if direction_to_target.y > 0:
			current_direction = "SOUTH"
		else:
			current_direction = "NORTH"

func _stop_moving()->void:
	is_stunned = true
	set_physics_process(false)

func enter()->void:
	is_stunned = false
	set_physics_process(true)

func unstun()->void:
	is_stunned = false


func _on_one_timer_timeout() -> void:
	change_direction()

func _unprocess()->void:
	set_physics_process(false)
	set_process(false)
