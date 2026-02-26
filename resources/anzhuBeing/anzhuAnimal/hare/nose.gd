extends Area2D
class_name Nose

var is_player_smelled: bool = false
#
#func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)
#
##
#func _on_body_exited(body: Node2D) -> void:
	#if body is Player:
		#is_player_in_earshot = false
#
#
#func _on_body_entered(body: Node2D) -> void:
	#if body is Player:
		#is_player_in_earshot = true
