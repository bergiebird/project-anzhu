## This is not a "VisibleOnScreenNotifier2D" because that would trigger when
## the character is hidden by the left/right panels. So a bespoke version of it now
## exists for now.
@abstract
extends Area2D
class_name Eyesight


signal player_is_spotted
signal player_un_spotted


var is_spotted: bool = false:
	set(v):
		if v == is_spotted:
			return
		is_spotted = v
		if is_spotted:
			player_is_spotted.emit()
		else:
			player_un_spotted.emit()
		if has_grievance:
			if is_spotted:
				parent.publish_event.emit("player_spotted")
			else:
				parent.publish_event.emit("player_out_of_sight")

var has_grievance: bool = false:
	set(v):
		if v == has_grievance:
			return
		has_grievance = v
		if is_spotted:
			parent.publish_event.emit('change_goals', 'Hunt')

@onready var parent: AnzhuBeing = get_parent()
@onready var shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(get_spotted)
	body_exited.connect(get_unspotted)
	__ready()


func get_spotted(body: Node2D) -> void:
	if body is Player:
		is_spotted = true


func get_unspotted(body: Node2D) -> void:
	if body is Player:
		is_spotted = false


func loud_noise(_who_made_noise, _where_noise_came_from, _how_loud_was_noise) -> void:
	_loud_noise(_who_made_noise, _where_noise_came_from, _how_loud_was_noise)

func _loud_noise(_who_made_noise, _where_noise_came_from, _how_loud_was_noise):pass
func __ready():pass
