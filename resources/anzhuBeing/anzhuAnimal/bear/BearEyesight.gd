@icon('res://resources/anzhuBeing/eyesight/icon_visibility.png')
extends Eyesight
class_name BearEyesight

func __signaler():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	Signalton.loud_noise.connect(loud_noise)


func loud_noise(_who_made_noise, _where_noise_came_from, _how_loud_was_noise):
	if is_spotted:
		has_grievance = true

func _on_body_entered(body: Node2D):
	if body is Player:
		is_spotted = true

func _on_body_exited(body: Node2D):
	if body is Player:
		is_spotted = false




#region #========================================================# DEBUG
@export_category('DEBUG')
@export var debug_eyesight :bool = false
func debug():
	debug_eyesight = true
#endregion
