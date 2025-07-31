@icon('res://resources/environment/objectsSmart/sign/sign.png')
extends StaticBody2D
class_name Sign

@export_multiline var sign_contents :String = ''' '''
@export_multiline var visual_description :String = """"""

@onready var interactible :Interactible= $Interactible

func _ready():
	interactible.player_entered_the_space.connect(_player_entered_the_space)
	$Mask.initial_output(visual_description)

func _player_entered_the_space(is_in_range: bool):
	Sgnl.console_read_sign.emit(is_in_range, self, sign_contents)
