class_name AnimalAnimations extends AnimatedSprite2D #AnimalActions.gd
@onready var parent = get_parent()

func was_struck()->void:
	var is_colored :bool = false
	for index :int in 4:
		is_colored = !is_colored
		if is_colored:
			parent.modulate = Swatchton.RED_TOMATO
		else:
			parent.modulate = Swatchton.BASIC_WHITE
		await get_tree().create_timer(.4).timeout
	parent.modulate = Swatchton.BASIC_WHITE

func update_animations(anim_name :String):
	animation = anim_name

func update_direction(bol :bool):
	flip_h = bol

func has_died():
	update_animations("Dead")








































#region # DEBUG
@export_group('DEBUG')
@export var debug_actions :bool = false

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_actions = true
#endregion
