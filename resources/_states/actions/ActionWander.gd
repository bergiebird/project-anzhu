class_name ActionWander extends ActionState #ActionWander.gd

@export var movement_speed: int = 10
var current_directional_velocity :Vector2 = Vector2.UP
@onready var D :Directon = Directon
@onready var timer = $WanderTimer

func _ready()->void:
	timer.timeout.connect(func():
		current_directional_velocity = Directon.get_vectors_with_string(parent.change_direction()))

func enter()->void:
	timer.start()
func exit()->void:
	timer.stop()

func physics_update(delta :float)->void:
	if grandparent.is_stunned:
		return
	grandparent.velocity_force = current_directional_velocity * movement_speed * delta





func update(delta :float)->void: pass
