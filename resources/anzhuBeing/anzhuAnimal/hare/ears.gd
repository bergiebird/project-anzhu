extends Area2D
class_name Ears

signal heard_a_noise(who: AnzhuBeing, where: Vector2)

var is_player_in_earshot: bool = false

@onready var shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	Sgnl.loud_noise.connect(_on_loud_noise)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_in_earshot = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_in_earshot = true


func _on_loud_noise(who: AnzhuBeing, where: Vector2, _db: float):
	if is_player_in_earshot:
		heard_a_noise.emit(who, where)
