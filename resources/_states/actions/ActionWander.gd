class_name ActionWander extends ActionState

@export var movement_speed :int = 10
var current_directional_velocity :Vector2 = Vector2.UP
@onready var timer :Timer = $WanderTimer #should probably do something with this. I deleted it



func ___enter()->void:
	timer.start()
func ___exit()->void:
	timer.stop()

func physics_update(delta :float)->void:
	if not grandparent.is_stunned:
		grandparent.velocity_force = current_directional_velocity * movement_speed * delta
