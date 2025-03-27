@icon("res://warehouse/_icons/node/icon_file.png")
class_name State extends Node #state.gd
signal goal_transition(goal_name :String)
signal action_transition(action_name :String)
signal entered(self_name :String)
signal exited(self_name :String)
@export var self_debug :bool
var parent
var grandparent
var animal_icon = ""
@onready var what_state_type :String = "[color=yellow][b]Goal: [/b] " + self.name + '[/color]'


func _ready() -> void:
	if self is ActionState:
		print(self.name)
		what_state_type = "[color=seashell]Action: " + self.name + '[/color]'

func on_enter()->void: ## Override this and on_enter, the signal, and debug will not function
	if self_debug:
		print_rich( animal_icon + "[color=firebrick] Entering [/color]" + what_state_type )
	enter_emit()
	virtual_enter()
	enter()
func virtual_enter()->void:pass
func enter()->void:pass


func update(_delta:float)->void:
	if self_debug:
		print_rich("[bgcolor=purple][color=white]UPDATE ERROR [/color][/bgcolor] [color=yellow]"+ self.name + " has not been assigned a process function[/color]")

func physics_update(_delta:float)->void:
	if self_debug:
		print_rich("[bgcolor=blue][color=white]PHYSICS ERROR [/color][/bgcolor] [color=yellow]" + self.name + " has not been assigned a physics_process function[/color]")

func enter_emit(string_name :String = self.name)->void:
	entered.emit(string_name)

func exit_emit(string_name :String = self.name)->void:
	exited.emit(string_name)

func on_exit()->void:
	if self_debug:
		print_rich( animal_icon + "[color=dimgray] Leaving [/color] " + what_state_type)
	exit_emit()
	exit()
	parent.transition_part_2()
func virtual_exit()->void: pass
func exit()->void: pass
func get_scenes_node_dictionary(incoming_dictionary :Dictionary)->void: pass
