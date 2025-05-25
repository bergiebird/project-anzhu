@icon("res://warehouse/icons/node/icon_follower.png")
extends Node
class_name GoTo

var is_stunned :bool= false
@onready var parent :AnzhuBeing = get_parent()
@onready var location :Area2D = $Location

func _ready():
	_debug()
	location.global_position = Vector2.ZERO
	location.body_entered.connect(func(body): if body.name == parent.name: parent.publisher_null.emit("reached_target"))

func set_GoTo_node(target :Node2D=null):
	if target: location.global_position = target.global_position
	else:      location.global_position = parent.global_position + randomized_distance()
	parent.publisher_one.emit('new_target_position', location.global_position)

func change_actions(new_action :String):
	if new_action == "Stunned":
		parent.publisher_null.emit("reached_target")

func randomized_distance()->Vector2:
	return Vector2(Directon.choose_random_direction() * Libraryton.rng.randi_range(15,30))

#region    #============================================================# Debug
@export_group("Debug")
@export var debug_self :bool = false
@onready var debug_sprite :Sprite2D = location.get_node('DebugSprite')

func _debug():
	debug_sprite.visible = debug_self
#endregion #============================================================# Debug
