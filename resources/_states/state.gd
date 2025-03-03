class_name State extends Node #state.gd
signal goal_transition(goal_name :String)
signal action_transition(action_name :String)
signal entered(self_name :String)
signal exited(self_name :String)
@export var self_debug :bool
@onready var parent = get_parent()
@onready var grandparent = parent.get_parent()

func enter()->void:
	if self_debug: print_rich("[color=yellow][b]" + self.name + "[/b][/color]")
	enter_emit()
	on_enter()
func on_enter()->void:
	pass
func exit()->void:
	if self_debug: print_rich("[color=white][b]" + self.name + "[/b][/color]")
	exit_emit()
	on_exit()
func on_exit()->void:
	pass
func update(_delta:float)->void:
	if self_debug: print_rich("[bgcolor=purple][color=white]UPDATE ERROR [/color][/bgcolor] [color=yellow]" + self.name + " has not been assigned a process function[/color]")
func physics_update(_delta:float)->void:
	if self_debug: print_rich("[bgcolor=blue][color=white]PHYSICS ERROR [/color][/bgcolor] [color=yellow]" + self.name + " has not been assigned a physics_process function[/color]")

func enter_emit(string_name :String = self.name)->void:
	entered.emit(string_name)

func exit_emit(string_name :String = self.name)->void:
	exited.emit(string_name)
