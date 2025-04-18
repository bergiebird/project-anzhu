@icon("res://warehouse/_icons/node/icon_file.png")
class_name State extends Node #state.gd
var parent
var grandparent

func collect_dictionary(incoming_dictionary, incoming_parent)->void:
	parent = incoming_parent
	grandparent = incoming_dictionary['scene_root']
	animal_icon = grandparent.animal_icon
	_collect_dictionary(incoming_dictionary)

func _ready() -> void:
	if self is ActionState and self_debug:
		what_state_type = "[color=seashell]Action: " + self.name + '[/color]'

func on_enter()->void: ## Override this and on_enter, the signal, and debug will not function
	if self_debug:
		print_rich( animal_icon + "[color=firebrick] Entering [/color]" + what_state_type )
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


func on_exit()->void:
	if self_debug:
		print_rich( animal_icon + "[color=dimgray] Leaving [/color] " + what_state_type)
	exit()
	parent.transition_part_2()





##VIRTUALS
func virtual_exit()->void: pass
func exit()->void: pass
func get_scenes_node_dictionary(incoming_dictionary :Dictionary)->void: pass
func _collect_dictionary(incoming_dictionary)->void: pass





###
## DEBUG
###
@export var self_debug :bool
var animal_icon = ""
@onready var what_state_type :String = "[color=yellow][b]Goal: [/b] " + self.name + '[/color]'
