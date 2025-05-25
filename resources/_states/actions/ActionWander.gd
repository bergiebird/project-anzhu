extends ActionState
class_name ActionWander

var target_acquired :bool = false
func ___get_state_value(_parent :StateMachine): which_state = _parent.AnimalActions.Wander


func ___enter():
	grandparent.publisher_one.emit("update_animations", "Wander")
	grandparent.publisher_null.emit("set_GoTo_node")

func on_location_reached():
	if is_active:
		grandparent.publisher_null.emit("set_GoTo_node")

func new_target_position(_incoming_position :Vector2):
	if is_active:
		target_acquired = true

func ___exit():
	target_acquired = false

func _physics_process(_delta):
	if target_acquired:
		grandparent.publisher_one.emit("move_towards_target", grandparent.SpeedType.WALK)
