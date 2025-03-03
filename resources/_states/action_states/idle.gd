extends ActionState #idle.gd

@onready var character :CharacterBody2D = get_parent().get_parent()
@onready var move_speed :int = character.move_speed
var wander_direction :Vector2
var wander_time :float


func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass
