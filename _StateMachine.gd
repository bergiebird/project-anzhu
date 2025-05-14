
@icon("res://warehouse/icons/misc/icons8-bot-100.png")
class_name StateMachine extends Node2D

@onready var parent :AnzhuBeing = get_parent()

var states
var current_state :State

func _ready()->void:
	for child in get_children():             # May be redundant as statemachine gets same children
		child.___get_state_value(self)                    # Each state initializes its own AnimalActions key
		states.which_state = child                # Put together dictionary
	__ready()

func on_transition(state :State)->void:
	if current_state: current_state._exit(state)
	else:                     state._enter()
	current_state = state


#region VIRTUALS
func __ready()->void:pass
