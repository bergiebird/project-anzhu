class_name Breath extends GPUParticles2D #Breath.gd

func _ready() -> void:
	position = Vector2(1.0, -1.5)

func change_breath_direction(flipped_h:bool)->void:
	position.x *= -1
	process_material.direction.x *= -1
