extends AnimatedSprite2D
class_name AnimalAnimations

@onready var parent = get_parent()

func update_animations(anim_name :String):
	if animation != anim_name:
		animation = anim_name
		play()

func update_direction(bol :Dictionary):
	flip_h = bol["Flip"]

func has_died():
	update_animations("Dead")



#region # DEBUG
@export_group('DEBUG')
@export var debug_self :bool = false

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_self = true
#endregion
