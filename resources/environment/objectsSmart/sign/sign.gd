@icon('res://resources/environment/objectsSmart/sign/sign.png')
class_name Sign extends StaticBody2D

signal publisher_null(method_name :String)
signal publisher_one(method_name :String, one :Variant)
signal publisher_two(method_name :String, one :Variant, two :Variant)
signal publisher_three(method_name :String, one :Variant, two :Variant, three :Variant)

@export_multiline var sign_contents :String = '''
Test Test Test
Somebody once told me, the world is going to roll me
I ain't the sharpest tool in the shed.
She was looking kind of dumb with a finger and her thumb
in the shape of an L on her forehead

Well the years start coming and the years start coming
'''

var console :RichTextLabel

func _ready() -> void:
	Libraryton.console_reference.connect(func(ref:RichTextLabel): console = ref)
	publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))
	publisher_two.connect(func(func_name, one :Variant, two :Variant): Observerton.subscribe_two(self, func_name, one, two))

func player_left_the_space():
	console.start_disappear_timer(self)

func player_entered_the_space():
	console.sign_text(sign_contents,self)
