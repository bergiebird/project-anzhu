extends Node2D
class_name Ability

var parent :Abilities:
	set(value):
		parent = value
		_parent_set()
		grandparent = parent.get_parent()

var grandparent :Player:
	set(value):
		grandparent = value
		_grandparent_set()

func _ready():
	parent = get_parent()
	set_process(false)
	set_physics_process(false)
	__ready()

func  __ready():
	pass

func _parent_set():
	pass

func _grandparent_set():
	pass

#region    #=================================================# DEBUG
@export var debug_self :bool
#endregion #=================================================# DEBUG
