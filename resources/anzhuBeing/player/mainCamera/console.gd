
class_name Console
extends RichTextLabel


signal is_text_on_screen(the_text: bool)

var current_visibility_of_text: bool
var current_sign: StaticBody2D

@onready var timer: Timer = $TextDisappearTimer


func _ready() -> void:
	Sgnl.console_read_sign.connect(read_sign)
	Sgnl.update_console.connect(_on_description_read)
	Inputon.cursor_movement_report.connect(_set_text_visibility)
	text = ""


func _on_description_read(the_text: String) -> void:
	is_text_on_screen.emit(true)
	text ="[i][fx]\n" + the_text
	visible = true
	timer.start()


func read_sign(is_in_range: bool, incoming_sign: Sign, incoming_text: String) -> void:
	if is_in_range:
		timer.stop()
		is_text_on_screen.emit(true)
		text ="[i][fx]\n" + incoming_text
		visible = true
		current_sign = incoming_sign
	elif current_sign == incoming_sign:
		timer.start()


func _set_text_visibility(bol: bool) -> void:
	current_visibility_of_text = bol


func _on_text_disappear_timer_timeout() -> void:
	visible = current_visibility_of_text
	is_text_on_screen.emit(false)
