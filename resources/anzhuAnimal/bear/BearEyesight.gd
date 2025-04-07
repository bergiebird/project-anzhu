extends VisibleOnScreenNotifier2D #BearEyesight.gd
signal sight_update(string_name :String)

@export_category('DEBUG')
@export var debug_eyesight :bool = false
var has_grievance :bool = false
var is_spotted :bool = false
@onready var parent :Node = get_parent()

func _ready() -> void:
	signal_connector()

func _on_screen_exited() -> void:
	if has_grievance:
		sight_update.emit("OutOfSight")
	is_spotted = false

func _on_screen_entered() -> void:
	if has_grievance:
		sight_update.emit("Spotted")
	is_spotted = true

func just_shot()->void:
	if has_grievance:
		return
	has_grievance = true

func attack_loud_noise()->void:
	if is_spotted:
		parent.change_goals('Hunt')

func debug()->void:
	debug_eyesight = true

func signal_connector()->void:
	self.screen_entered.connect(_on_screen_entered)
	self.screen_exited.connect(_on_screen_exited)
	parent.was_struck.connect(just_shot)
	Signalton.gunshot.connect(attack_loud_noise)
