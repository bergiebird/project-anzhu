extends Area2D

@onready var collider :CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	get_parent().publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))

func collision_size_delivery(new_size :Vector2):
	collider.shape.size = new_size
	print('collider sidze ', collider.shape.size, position)


func _on_mouse_entered() -> void:
	print(2)


func _on_mouse_exited() -> void:
	print(5)
