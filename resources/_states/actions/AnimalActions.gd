class_name AnimalAnimations extends AnimatedSprite2D #AnimalActions.gd

@onready var parent = get_parent()

func _ready()->void:
	parent.publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))



func direction_flipped(bol :bool):
	flip_h = bol


#region # DEBUG
@export_group('DEBUG')
@export var debug_actions :bool = false

func debug()->void:
	print_rich('[color=yellow]Animations debugging enabled . . .[/color]')
	debug_actions = true
#endregion
