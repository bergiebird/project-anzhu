class_name ActionWander extends ActionState #ActionWander.gd

@export var movement_speed: int = 10
var current_directional_velocity :Vector2 = Vector2.UP
@onready var D :Directon = Directon
@onready var timer :Timer = $WanderTimer

func _parent_reference_acquired(_parent :Node)->void:
	Debuggerton.signal_checker([
		timer.timeout.connect(func()->void:
			current_directional_velocity = Directon.get_vectors_with_string(str(parent.change_direction())))])

func enter()->void:
	timer.start()
func exit()->void:
	timer.stop()

func physics_update(delta :float)->void:
	if grandparent.is_stunned:
		return
	grandparent.velocity_force = current_directional_velocity * movement_speed * delta





func update(_delta :float)->void: pass
