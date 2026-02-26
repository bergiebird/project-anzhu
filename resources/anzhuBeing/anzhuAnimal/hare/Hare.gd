@icon("res://resources/anzhuBeing/anzhuAnimal/hare/Hare.png")
extends AnzhuAnimal
class_name Hare


@onready var mask: Mask = $Mask
@onready var anim: AnimatedSprite2D = $Animations
@onready var eyes: HareSight = $Eyes
@onready var goto: GoTo = $GoTo





func _on_hare_sight_player_is_spotted() -> void:
	pass # Replace with function body.


func _on_hare_sight_player_un_spotted() -> void:
	## Return to normal state if is provoked
	pass # Replace with function body.


func _on_ears_heard_a_noise(_who: AnzhuBeing, _where: Vector2) -> void:
	pass # Replace with function body.
