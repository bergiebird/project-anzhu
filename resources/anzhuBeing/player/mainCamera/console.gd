
class_name Console
extends RichTextLabel

signal text_on_screen(the_text: bool)

var current_visibility_of_text: bool
var current_sign: StaticBody2D

@onready var timer: Timer = $TextDisappearTimer


func _ready():
	Sgnl.console_read_sign.connect(read_sign)
	Inputon.cursor_movement_report.connect(func(bol :bool): current_visibility_of_text = bol)
	timer.timeout.connect(_on_timeout)
	text = ""


func read_sign(is_in_range: bool, incoming_sign: Sign, incoming_text: String):
	if is_in_range:
		timer.stop()
		text_on_screen.emit(true)
		text ="[i][fx]\n" + incoming_text
		visible = true
		current_sign = incoming_sign
	elif current_sign == incoming_sign:
		timer.start()


func _on_timeout():
	visible = current_visibility_of_text
	text_on_screen.emit(false)
