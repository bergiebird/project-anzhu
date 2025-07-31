extends Node2D
class_name State

var parent :Node:
	set(value):
		parent = value
		__parent_acquired()
		___parent_acquired()
		grandparent = parent.get_parent()

var grandparent :AnzhuBeing:
	set(value):
		grandparent = value
		grandparent.publish_event.connect(func(func_name:String, data:Variant=null): Lib.Observe.subscribe_to_event(self, func_name, data))
		__grandparent_acquired()
		___grandparent_acquired()

var is_active :bool
var which_state

@onready var _can_process :bool = true
@onready var _can_physics_process :bool = true

#region Basics
func _ready():
	parent = get_parent()
	_action_state_debug()
	__ready()
	___ready()

func _enter():
	is_active = true
	if self_debug:
		print_rich( entity_icon + "[color=firebrick] Entering: [/color]" + what_state_type )
	__enter()
	___enter()
	set_physics_process(_can_physics_process)
	set_process(_can_process)

#func _process(_delta: float) -> void:
	#_debug_update()
#
#func _physics_process(_delta: float) -> void:
	#_debug_physics_update()

func _exit()->void:
	set_physics_process(false)
	set_process(false)
	is_active = false
	if self_debug:
		print_rich( entity_icon + "[color=dimgray] Leaving: [/color] " + what_state_type)
	__exit()
	___exit()
#endregion





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
func ___get_state_value(_parent :StateMachine):
	print(self.name + " has not set their personal state value")
#endregion

#region # DEBUG
@export var self_debug :bool = false
var entity_icon :String = ""
@onready var what_state_type :String = "[color=yellow][b]Goal: [/b] " + self.name + '[/color]'

func _action_state_debug():
	if self is ActionState and self_debug:
		what_state_type = "[color=seashell]Action: " + self.name + '[/color]'
	if self is ActionState and self_debug :
		printt(self, parent, grandparent)



#func _debug_update():
	#if self_debug:
		#print_rich("[bgcolor=purple][color=white]UPDATE ERROR [/color][/bgcolor] [color=yellow]" \
		#+ self.name + " has not been assigned a process function[/color]")
#func _debug_physics_update():
	#if self_debug:
		#print_rich("[bgcolor=blue][color=white]PHYSICS ERROR [/color][/bgcolor] [color=yellow]"  \
		#+ self.name + " has not been assigned a physics_process function[/color]")
#endregion
