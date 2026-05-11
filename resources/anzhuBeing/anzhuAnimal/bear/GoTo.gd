@icon("res://warehouse/icons/node/icon_follower.png")
extends Node
class_name GoTo

signal new_target_position(new_position: Vector2)
signal reached_target

@onready var location: Area2D = $Location
@onready var parent: AnzhuBeing = get_parent()


func _ready() -> void:
	location.global_position = Vector2.ZERO
	location.body_entered.connect(func(body):
		if body.name == parent.name:
			reached_target.emit())


func set_GoTo_node(target: Node2D = null) -> void:
	if target:
		var target_global_position: Vector2 = target.global_position
		if _self_is_not_too_close_to_target(target_global_position):
			if Libraryton.rng.randi() % 2 == 1:
				target_global_position.y = parent.global_position.y
			else:
				target_global_position.x = parent.global_position.x
		location.global_position = target_global_position
	else:
		location.global_position = parent.global_position + randomized_distance()
	new_target_position.emit(location.global_position)


func _self_is_not_too_close_to_target(_target_global_position) -> bool:
	if not round(abs(_target_global_position.x)) >= round(abs(parent.global_position.x)):
		if not round(abs(_target_global_position.y)) >= round(abs(parent.global_position.y)):
			return true
	return false

## This argument is dynamic
func change_actions(new_action) -> void:
	if new_action is String:
		match new_action:
			"Stunned":
				reached_target.emit()


func randomized_distance() -> Vector2:
	return Vector2(Directon.choose_random_direction() * Libraryton.rng.randi_range(15,30))
