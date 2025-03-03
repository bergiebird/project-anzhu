@icon('res://resources/player/player.png')
extends CharacterBody2D #player.gd
@onready var movement_node :Node = %Movement
@onready var bgm = %BGM
@onready var anim :AnimatedSprite2D = %PlayerSprite

@export_group('Energy')
@export var max_energy :int = 10
@export var regen_rate :int = 1
var can_fire :bool = true
var can_move :bool = true
var is_efficient :bool = false

func _ready()->void:
	set_motion_mode(MOTION_MODE_FLOATING)
	movement_node.efficiency_check.connect(set_efficiency)

func _physics_process(_delta:float)->void:
	velocity = Vector2.ZERO
	if can_fire and can_move:
		_shoot()
	if can_move:
		movement_node.movement()
	move_and_slide()

func _shoot()->void:
	if Input.is_action_just_released('shoot'):
		can_fire = false
		can_move = false
		Signalton.gunshot.emit()

func can_do_stuff_again() -> void:
	can_fire = true
	can_move = true

func set_efficiency(new_value :bool)->void:
	is_efficient = new_value
func get_efficiency()->bool:
	return is_efficient
func set_can_fire(new_value :bool)->void:
	can_fire = new_value
func get_can_fire()->bool:
	return can_fire
func set_can_move(new_value :bool)->void:
	can_move = new_value
func get_can_move()->bool:
	return can_move
