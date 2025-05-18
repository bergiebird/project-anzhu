@icon("res://warehouse/icons/misc/icons8-bot-100.png")
class_name StateMachine extends Node2D

@onready var parent :AnzhuBeing = get_parent()

var states :Dictionary[int,State]
var current_state :State

func _ready()->void:
	for child in get_children():                      # May be redundant as statemachine gets same children
		child.___get_state_value(self)                 # Each state initializes its own AnimalActions key
		child.set_physics_process(false)
		child.set_process(false)
		states[child.which_state] = child                # Put together dictionary
	__ready()

func on_transition(state :State)->void:
	if current_state:
		current_state._exit()
	current_state = state
	current_state._enter()


#region VIRTUALS
func __ready()->void:pass
#endregion
