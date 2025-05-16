class_name ActionWander extends ActionState
@onready var timer :Timer = $WanderTimer #should probably do something with this. I deleted it.

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Wander

func ___enter()->void:
	grandparent.publisher_one.emit("update_animations", "Wander")
	timer.timeout.connect(_on_wander_timer_timeout)
	timer.start()
func ___exit()->void:
	timer.timeout.disconnect(_on_wander_timer_timeout)
	timer.stop()

func _on_wander_timer_timeout():
	_choose_random_direction()
	timer.wait_time = Libraryton.rng.randf_range(1.5,3.0)

func _choose_random_direction():
	var random_angle = Libraryton.rng.randf_range(0,2*PI)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	grandparent.parse_movement_vector(direction)
