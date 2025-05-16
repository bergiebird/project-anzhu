class_name Ability extends Node2D #_Ability.gd

var parent :Abilities:
	set(value):
		parent = value
		_parent_set()

var grandparent :Player:
	set(value):
		grandparent = value
		_grandparent_set()

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _parent_set()->void: pass

func _grandparent_set()->void: pass

func process_ability(_delta:float)->void: pass
