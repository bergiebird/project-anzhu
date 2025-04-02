extends Node2D # Interactable.gd

## Emitted after input and proximity has been validated
signal interacted

@export var interaction_text = "Press SPACE to interact"
@export var interaction_key = "jump"
@export var note_content = "This is a note."

var player_in_range = false
var ui_instance = null

func _ready():
	set_process(false)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('jump'):
		print('yarp')


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print('in')
		set_process(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print('out')
		set_process(false)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
