@icon('res://resources/environment/objectsSmart/sign/sign.png')
extends StaticBody2D
class_name Sign

signal publisher_null(method_name :String)
signal publisher_one(method_name :String, one :Variant)
signal publisher_two(method_name :String, one :Variant, two :Variant)
signal publisher_three(method_name :String, one :Variant, two :Variant, three :Variant)

@export_multiline var sign_contents :String = ''' '''
@export_multiline var visual_description :String = """"""
var console :RichTextLabel

func _ready():
	Libraryton.console_reference.connect(func(ref:RichTextLabel): console = ref)
	publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))
	publisher_two.connect(func(func_name, one :Variant, two :Variant): Observerton.subscribe_two(self, func_name, one, two))
	publisher_one.emit("override_visual_description", visual_description)

func player_left_the_space():
	console.start_disappear_timer(self)

func player_entered_the_space():
	console.sign_text(sign_contents,self)
