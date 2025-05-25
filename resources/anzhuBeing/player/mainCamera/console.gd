extends RichTextLabel

signal text_on_screen(bool)

var current_visibility_of_text :bool
var current_sign :StaticBody2D
@onready var timer :Timer = $TextDisappearTimer

func _ready():
	Libraryton.reference_emitter_deferred("console_reference", self)
	Signalton.update_console.connect(sign_text)
	Inputon.cursor_movement_report.connect(func(bol :bool): current_visibility_of_text = bol)
	timer.timeout.connect(_on_timeout)

func sign_text(incoming_text :String, incoming_sign :StaticBody2D = null):
	timer.stop()
	text_on_screen.emit(true)
	text ="[i][fx]\n" + incoming_text
	visible = true
	if incoming_sign:
		current_sign = incoming_sign

func start_disappear_timer(incoming_sign :StaticBody2D):
	if current_sign == incoming_sign:
		timer.start()

func _on_timeout():
	visible = current_visibility_of_text
	text_on_screen.emit(false)
