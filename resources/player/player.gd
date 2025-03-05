extends AnzhuPlayer #player.gd

@export_group('Energy')
@export var max_energy :int = 10
@export var regen_rate :int = 1
var can_fire :bool = true
var can_move :bool = true
var is_efficient :bool = false

func _physics_process(_delta:float)->void:
	velocity = Vector2.ZERO
	if can_fire and can_move:
		_shoot()
	if can_move:
		abilities.allow_movement()
	move_and_slide()

func _shoot()->void:
	if Input.is_action_just_released('shoot'):
		can_fire = false
		can_move = false
		Signalton.gunshot.emit()

func can_do_stuff_again()->void:
	can_fire = true
	can_move = true

func set_efficiency(boool :bool)->void:
	is_efficient = boool
func set_can_fire(boool :bool)->void:
	can_fire = boool
func set_can_move(boool :bool)->void:
	can_move = boool
func get_efficiency()->bool:
	return is_efficient
func get_can_fire()->bool:
	return can_fire
func get_can_move()->bool:
	return can_move
