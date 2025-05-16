
@icon("res://warehouse/icons/misc/icons8-bot-100.png")
class_name StateMachine extends Node2D

@onready var parent :AnzhuBeing = get_parent()

var states :Dictionary[int,State]
var current_state :State

func _ready()->void:
	parent.publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	parent.publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))
	parent.publisher_two.connect(func(func_name, one :Variant, two :Variant): Observerton.subscribe_two(self, func_name, one, two))
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
