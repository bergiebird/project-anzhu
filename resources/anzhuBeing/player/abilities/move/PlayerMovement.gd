@icon("res://resources/anzhuBeing/player/abilities/move/icons8-exercise-100.png")
extends Ability #PlayerMovement.gd

@export_group('Movement')
@export var efficient_bonus :int = 15
@export var run_bonus :int = 20
var parent :Abilities

var anim :AnimatedSprite2D
var grandparent :Player:
	set(value): if grandparent != value:
		grandparent = value
		anim = grandparent.get_node('Animations')

var speed_efficient :int
var speed_run :int
var speed_normal :int:
	set(value): if value != speed_normal:
		speed_normal = value
		speed_efficient = speed_normal + efficient_bonus
		speed_run = speed_efficient + run_bonus
var velocity :Vector2

func process_ability()->void:
	if speed_normal == 0: speed_normal = grandparent.move_speed
	if parent.can_move:
		velocity = Vector2.ZERO
		for direction in Directon.DIRECTIONS:
			Inputon.look_direction(direction)
			velocity = mover(direction)
			if velocity != Vector2.ZERO:
				break
		grandparent.velocity = velocity

func mover(direction)->Vector2:
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

func efficienctVelocity(speed, efficiency)->Vector2:
	parent.is_efficient = efficiency
	return velocity * speed
