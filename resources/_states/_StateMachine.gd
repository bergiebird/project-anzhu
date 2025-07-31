@icon("res://warehouse/icons/misc/icons8-bot-100.png")
extends Node2D
class_name StateMachine

var states :Dictionary[int, State]
var current_state :State

@onready var parent :AnzhuBeing = get_parent()

func _ready():
	for child :State in get_children():         # May be redundant as statemachine gets same children
		child.___get_state_value(self)           # Each state initializes its own AnimalActions key
		child.set_physics_process(false)
		child.set_process(false)
		states[child.which_state] = child        # Put together dictionary
	__ready()

func on_transition(state :State):
	if current_state:
		current_state._exit()
	current_state = state
	current_state._enter()

## Mono |I|W|
## Ligatures
## Programmer font

#region VIRTUALS
func __ready()->void:pass
#endregion
