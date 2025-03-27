extends VisibleOnScreenNotifier2D #BearEyesight.gd

@export_category('DEBUG')
@export var debug_eyesight :bool = false
var has_grievance :bool = false
var is_spotted :bool = false
@onready var parent :Node = get_parent()
signal sight_update(string_name :String)

func _ready() -> void:
	Signalton.gunshot.connect(attack_loud_noise)

func _on_screen_exited() -> void:
	if has_grievance: sight_update.emit("OutOfSight")
	is_spotted = false

func _on_screen_entered() -> void:
	if has_grievance: sight_update.emit("Spotted")
	is_spotted = true

func _just_shot(_action_name: String) -> void:
	if has_grievance: return
	has_grievance = true

func attack_loud_noise()->void:
	if is_spotted: parent.change_goals('Hunt')

func debug()->void:
	debug_eyesight = true
