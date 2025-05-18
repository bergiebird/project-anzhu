extends RichTextLabel

var current_visibility_of_text :bool
var current_sign :StaticBody2D

@onready var timer :Timer = $TextDisappearTimer

func _ready() -> void:
	Libraryton.reference_emitter_deferred("console_reference", self)
	Inputon.cursor_movement_report.connect(func(bol :bool): current_visibility_of_text = bol)
	timer.timeout.connect(_on_timeout)

func sign_text(incoming_text :String, incoming_sign :StaticBody2D):
	text ="[i][fx]" + incoming_text
	visible = true
	current_sign = incoming_sign

func start_disappear_timer(incoming_sign :StaticBody2D):
	if current_sign == incoming_sign:
		timer.start()

func _on_timeout():
	visible = current_visibility_of_text
