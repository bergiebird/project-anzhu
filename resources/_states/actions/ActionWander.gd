
class_name ActionWander
extends ActionState

var target_acquired :bool = false

func ___ready():
	if grandparent is Walrus:
		action_sfx = $WalrusRoar


func ___enter():
	if grandparent is Walrus:
		walrus_enter()
	grandparent.publish_event.emit("update_animations", "Wander")
	grandparent.publish_event.emit("set_GoTo_node")


func on_location_reached():
	if is_active:
		grandparent.publish_event.emit("set_GoTo_node")

func new_target_position(_incoming_position :Vector2):
	if is_active:
		target_acquired = true

func ___exit():
	target_acquired = false

func _physics_process(_delta :float):
	if target_acquired:
		grandparent.publish_event.emit("move_towards_target", "Walk")

#region WALRUS
func walrus_enter():
	action_sfx.play()
	if randi_range(0,3) == 3:
			pass
#endregion

#region BASIC
func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Wander
#endregion
