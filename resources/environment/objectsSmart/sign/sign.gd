@icon('res://resources/environment/objectsSmart/sign/sign.png')
extends StaticBody2D
class_name Sign

@export_multiline var sign_contents: String = ''' '''
@export_multiline var visual_description: String = """"""


func _ready():
	$Mask.initial_output(visual_description)


func _on_interactible_player_entered_the_space(is_in_range: Variant) -> void:
	Sgnl.console_read_sign.emit(is_in_range, self, sign_contents)
