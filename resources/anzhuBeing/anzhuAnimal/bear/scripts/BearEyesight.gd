extends Eyesight #BearEyesight.gd

var has_grievance :bool = false
var is_spotted :bool = false

func _ready() -> void:
	signaler()

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

func react_to_loud_noise(player :Player, location :Vector2, noise_db :float)->void:
	if is_spotted:
		parent.change_goals('Hunt')

func signaler()->void:
	self.screen_entered.connect(_on_screen_entered)
	self.screen_exited.connect(_on_screen_exited)
	parent.was_struck.connect(just_shot)
	Signalton.loud_noise.connect(react_to_loud_noise)
