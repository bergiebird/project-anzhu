@icon("res://resources/anzhuBeing/player/abilities/move/icons8-exercise-100.png")
extends Ability #PlayerMovement.gd

@export_group('Movement')
@export var efficient_bonus :int = 15
@export var run_bonus :int = 20

var anim :AnimatedSprite2D
var speed_efficient :int
var speed_run :int
var speed_normal :int
var velocity :Vector2

func _grandparent_set()->void:
	anim = grandparent.get_node('Animations')

func process_ability(_delta :float)->void:
	acquire_speeds()
	if parent.can_move:
		velocity = Vector2.ZERO
		for direction :String in Directon.DIRECTIONS:
			var input :String = Inputon.look_direction(direction)
			if input != "":
				var enput :int = Directon.ENUM_POS[input]
				if enput != grandparent.current_direction:
					grandparent.current_direction = enput
			velocity = mover(direction)
			if velocity != Vector2.ZERO:
				break
		grandparent.velocity = velocity

func mover(direction :String)->Vector2:
	if Inputon.move(direction):
		velocity = Directon.get_vectors_with_string(direction)
		if Inputon.aim(direction):
			velocity = efficienctVelocity(speed_run, true)
		elif Inputon.inverse_aim(direction):
			velocity = efficienctVelocity(speed_normal, false)
		else:
			if Directon.check_direction(direction):
				velocity = efficienctVelocity(speed_efficient, true)
			else:
				velocity = efficienctVelocity(speed_normal, false)
		return velocity
	return Vector2.ZERO

func efficienctVelocity(speed :int, efficiency :bool)->Vector2:
	parent.is_efficient = efficiency
	return velocity * speed

func acquire_speeds()->void:
	if speed_normal == 0:
		speed_normal = grandparent.move_speed
		speed_efficient = speed_normal + efficient_bonus
		speed_run = speed_efficient + run_bonus
