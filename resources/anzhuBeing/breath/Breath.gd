extends GPUParticles2D
class_name Breath

const INITIALIZED_POSITION: Vector2 = Vector2(1.0, -1.5)

var old_flip_h: bool = false

@onready var mat: ParticleProcessMaterial = process_material
@onready var grandparent: Player = get_parent().get_parent()

func _ready() -> void:
	if not process_material:
		process_material = load("uid://dvuuxouj12vys")
	position = INITIALIZED_POSITION
	lifetime = 4.5
	preprocess = 0.1
	explosiveness = 0.9
	randomness = 0.2
	emitting = true
	grandparent.publish_event.connect(
		func(func_name:String, data:Variant=null):
			Lib.Observe.subscribe_to_event(self, func_name, data))



func update_direction(new_direction: Dictionary) -> void:
	match new_direction["Name"]:
		'NORTH':
			mat.direction = Vector3.UP
			z_index = -1
			position = Vector2(0.0, -3.0)
		'SOUTH':
			mat.direction = Vector3.DOWN
			position = Vector2(0.0,-2.0)
			z_index = 1
		'EAST':
			mat.direction = Vector3.RIGHT
			z_index = 1
			position = Vector2(1.0,-1.0)
		'WEST':
			mat.direction = Vector3.LEFT
			z_index = 1
			position = Vector2(-1.0, -1.0)
