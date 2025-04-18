class_name ActionWander extends ActionState #ActionWander.gd

@export var movement_speed: int = 10
var current_directional_velocity :Vector2 = Vector2.UP
@onready var D :Directon = Directon
@onready var timer = $WanderTimer

func _ready()->void:
	timer.timeout.connect(update_direction)

func enter()->void:
	timer.start()
func exit()->void:
	timer.stop()

func physics_update(delta :float)->void:
	if grandparent.is_stunned:
		return
	grandparent.position += current_directional_velocity * movement_speed * delta

func update_direction()->void:
	current_directional_velocity = D.change_direction()





func update(delta :float)->void: pass
