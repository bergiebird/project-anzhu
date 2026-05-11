extends AnimatedSprite2D
class_name AnimalAnimations

@onready var parent: AnzhuBeing = get_parent()


func update_animations(anim_name: String) -> void:
	if animation != anim_name:
		animation = anim_name
		play()


func update_direction(dic: Dictionary) -> void:
	flip_h = dic["Flip"]


func has_died() -> void:
	update_animations("Dead")
