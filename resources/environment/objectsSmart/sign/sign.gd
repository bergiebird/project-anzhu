@icon('res://resources/environment/objectsSmart/sign/sign.png')
extends StaticBody2D
class_name Sign

signal publish_event(String, Variant)

@export_multiline var sign_contents :String = ''' '''
@export_multiline var visual_description :String = """"""
var console :RichTextLabel

func _ready():
	Signalton.console_reference.connect(func(ref:RichTextLabel): console = ref)
	publish_event.connect(func(func_name:String, data:Variant=null):L.Observe.subscribe_to_event(self, func_name, data))
	publish_event.emit("override_visual_description", visual_description)

func player_left_the_space():
	console.start_disappear_timer(self)

func player_entered_the_space():
	console.sign_text(sign_contents,self)
