@icon('res://resources/anzhuBeing/eyesight/icon_visibility.png')
extends Area2D
class_name BearEyesight

var is_spotted :bool = false:
	set(value): if value != is_spotted:
		is_spotted = value
		if has_grievance:
			match is_spotted:
				true:
					parent.publisher_null.emit("player_spotted")
				false:
					parent.publisher_null.emit("player_out_of_sight")
var has_grievance :bool = false:
	set(value): if value != has_grievance:
		has_grievance = value
		if is_spotted:
			parent.publisher_one.emit('change_goals', 'Hunt')

@onready var parent :AnzhuBeing = get_parent()

func _ready()->void:
	_signaler()
func _signaler()->void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func loud_noise()->void:
	if is_spotted:
		has_grievance = true

func was_struck():
	has_grievance = true
	parent.publisher_one.emit("start_stun", "Chase")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_spotted = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_spotted = false




#region #========================================================# DEBUG
@export_category('DEBUG')
@export var debug_eyesight :bool = false
func debug():
	debug_eyesight = true
#endregion
