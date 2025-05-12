@icon("res://warehouse/_icons/node/icon_file.png")
class_name State extends Node #state.gd
var parent :Node
var grandparent :AnzhuAnimal

func _ready() -> void:
	parent = get_parent()
	grandparent = parent.get_parent()
	grandparent.observer_null.connect(func(func_name): Observerton.match_null(self, func_name))
	grandparent.observer_one.connect(func(func_name, one :Variant): Observerton.match_one(self, func_name, one))
	grandparent.observer_two.connect(func(func_name, one :Variant, two :Variant): Observerton.match_two(self, func_name, one, two))

	_action_state_debug()
	__ready()
	___ready()

func _enter()->void:
	if self_debug: print_rich( animal_icon + "[color=firebrick] Entering [/color]" + what_state_type )
	__enter()
	___enter()

func update(_delta:float)->void:
	_debug_update()

func physics_update(_delta:float)->void:
	_debug_physics_update()

func _exit()->void:
	if self_debug: print_rich( animal_icon + "[color=dimgray] Leaving [/color] " + what_state_type)
	__exit()
	___exit()
	parent.transition_part_2()





#region #VIRTUALS
func __enter()->void:pass
func ___enter()->void:pass
func __ready()->void:pass
func ___ready()->void:pass
func __exit()->void: pass
func ___exit()->void: pass
#endregion

#region # DEBUG

@export var self_debug :bool
var animal_icon :String = ""
@onready var what_state_type :String = "[color=yellow][b]Goal: [/b] " + self.name + '[/color]'

func _action_state_debug():
	if self is ActionState and self_debug: what_state_type = "[color=seashell]Action: " + self.name + '[/color]'
	if self is ActionState:
		printt(self, parent, grandparent)

func _debug_update():
	if self_debug: print_rich("[bgcolor=purple][color=white]UPDATE ERROR [/color][/bgcolor] [color=yellow]" + self.name + " has not been assigned a process function[/color]")
func _debug_physics_update():
	if self_debug: print_rich("[bgcolor=blue][color=white]PHYSICS ERROR [/color][/bgcolor] [color=yellow]"  + self.name + " has not been assigned a physics_process function[/color]")

#endregion
