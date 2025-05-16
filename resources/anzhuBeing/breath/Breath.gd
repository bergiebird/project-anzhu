class_name Breath extends GPUParticles2D #Breath.gd

const INITIALIZED_POSITION :Vector2 = Vector2(1.0, -1.5)
var old_flip_h :bool = false
@onready var mat :ParticleProcessMaterial = process_material
@onready var parent :PlayerAnimations = get_parent()
@onready var grandparent :Player = parent.get_parent()

func _ready()->void:
	position = INITIALIZED_POSITION

	grandparent.publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))


func change_breath_direction(new_direction :String)->void:
	match new_direction:
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

###
##	DEBUG
###
@export var debug :bool = false
