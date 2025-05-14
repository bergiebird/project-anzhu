class_name BearEyeSight extends Eyesight #BearEyesight.gd

var has_grievance :bool = false
var is_spotted :bool = false

func _on_screen_exited() -> void:
	if has_grievance:
		parent.observer_null.emit("player_out_of_sight")
	is_spotted = false

func _on_screen_entered() -> void:
	if has_grievance:
		parent.observer_null.emit("player_spotted")
	is_spotted = true

func just_shot()->void:
	if not has_grievance:
		has_grievance = true

func loud_noise(_player :Player, _location :Vector2, _noise_db :float)->void:
	if is_spotted:
		parent.change_goals('Hunt')

func __signaler()->void:
	screen_entered.connect(_on_screen_entered)
	screen_exited.connect(_on_screen_exited)
	parent.publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	Signalton.loud_noise.connect(loud_noise)
