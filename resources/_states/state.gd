@icon("res://warehouse/_icons/node/icon_file.png")
class_name State extends Node #state.gd
signal goal_transition(goal_name :String)
signal action_transition(action_name :String)
signal entered(self_name :String)
signal exited(self_name :String)
@export var self_debug :bool
var parent
var grandparent

## Override this and on_enter, the signal, and debug will not function
func on_enter()->void:
	if self_debug:
		print_rich("[color=yellow][b]" + self.name + "[/b][/color]")
	enter_emit()
	virtual_enter()
	enter()

func virtual_enter()->void:
	pass
func enter()->void:
	pass
func on_exit()->void:
	if self_debug:
		print_rich("[color=white][b]" + self.name + "[/b][/color]")
	exit_emit()
	exit()
func virtual_exit()->void:
	pass
func exit()->void:
	pass
func update(_delta:float)->void:
	if self_debug:
		print_rich("[bgcolor=purple][color=white]UPDATE ERROR [/color][/bgcolor] [color=yellow]"
		+ self.name + " has not been assigned a process function[/color]")
func physics_update(_delta:float)->void:
	if self_debug:
		print_rich("[bgcolor=blue][color=white]PHYSICS ERROR [/color][/bgcolor] [color=yellow]"
		+ self.name + " has not been assigned a physics_process function[/color]")

func enter_emit(string_name :String = self.name)->void:
	entered.emit(string_name)

func exit_emit(string_name :String = self.name)->void:
	exited.emit(string_name)
