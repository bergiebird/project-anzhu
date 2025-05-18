class_name GoTo extends Node

var is_stunned :bool= false:
	set(value): if value != is_stunned:
		is_stunned = value
		if was_stunned:
			parent.publisher_null.emit("reached_target")
			was_stunned = false

var was_stunned = false

@onready var parent :AnzhuBeing = get_parent()
@onready var location :Area2D = $Location

func _ready():
	_debug()
	location.global_position = Vector2.ZERO
	location.body_entered.connect(_location_reached)

func set_new_GoTo_location():
	var direction :Vector2i = Directon.choose_random_direction()
	var random_ra :int = Libraryton.rng.randi_range(15,30)
	var new_location = parent.global_position + Vector2(direction*random_ra)
	location.global_position = new_location
	parent.publisher_one.emit('new_target_position', location.global_position)

func _location_reached(body :Node2D):
	if body.name == parent.name:
		if not is_stunned:
			parent.publisher_null.emit("reached_target")
		else:
			was_stunned = true


func set_GoTo_node(target :Node2D):
	location.global_position = target.global_position
	parent.publisher_one.emit('new_target_position', location.global_position)


func change_actions(new_action :String):
	match new_action:
		"Stunned":
			is_stunned = true
		_:
			is_stunned = false

#region    #============================================================# Debug
@export_group("Debug")
@export var debug_self :bool = false
@onready var debug_sprite :Sprite2D = location.get_node('DebugSprite')

func _debug():
	debug_sprite.visible = debug_self
#endregion #============================================================# Debug
