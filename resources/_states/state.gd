
class_name State extends Node2D #state.gd
var parent :Node:
	set(value):
		parent = value
		__parent_acquired()
		___parent_acquired()
var grandparent :AnzhuAnimal:
	set(value):
		grandparent = value
		printt(self.name, grandparent)
		__grandparent_acquired()
		___grandparent_acquired()
var is_active :bool
var which_state
@onready var _is_processing :bool = true
@onready var _is_physicing :bool = true
func _ready() -> void:
	parent = get_parent()
	grandparent = parent.get_parent()
	grandparent.publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	grandparent.publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))
	grandparent.publisher_two.connect(func(func_name, one :Variant, two :Variant): Observerton.subscribe_two(self, func_name, one, two))
	_action_state_debug()
	__ready()
	___ready()

func _enter()->void:
	is_active = true
	if self_debug:
		print_rich( animal_icon + "[color=firebrick] Entering [/color]" + what_state_type )
	__enter()
	___enter()
	set_physics_process(_is_physicing)
	set_process(_is_processing)

func _process(_delta: float) -> void:
	_debug_update()

func _physics_process(_delta: float) -> void:
	_debug_physics_update()

func _exit()->void:
	set_physics_process(false)
	set_process(false)
	is_active = false
	if self_debug:
		print_rich( animal_icon + "[color=dimgray] Leaving [/color] " + what_state_type)
	__exit()
	___exit()

#region #VIRTUALS
func __enter()->void:pass
func ___enter()->void:pass
func __ready()->void:pass
func ___ready()->void:pass
func __exit()->void: pass
func ___exit()->void: pass
func __parent_acquired()->void:pass
func ___parent_acquired()->void:pass
func __grandparent_acquired()->void:pass
func ___grandparent_acquired()->void:pass
func ___get_state_value(_parent :StateMachine):pass
#endregion

#region # DEBUG
@export var self_debug :bool = false
var animal_icon :String = ""
@onready var what_state_type :String = "[color=yellow][b]Goal: [/b] " + self.name + '[/color]'

func _action_state_debug():
	if self is ActionState and self_debug:
		what_state_type = "[color=seashell]Action: " + self.name + '[/color]'
	if self is ActionState and self_debug :
		printt(self, parent, grandparent)

func _debug_update():
	if self_debug:
		print_rich("[bgcolor=purple][color=white]UPDATE ERROR [/color][/bgcolor] [color=yellow]" \
		+ self.name + " has not been assigned a process function[/color]")
func _debug_physics_update():
	if self_debug:
		print_rich("[bgcolor=blue][color=white]PHYSICS ERROR [/color][/bgcolor] [color=yellow]"  \
		+ self.name + " has not been assigned a physics_process function[/color]")
#endregion
