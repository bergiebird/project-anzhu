@icon("res://resources/anzhuBeing/player/abilities/move/icons8-exercise-100.png")
extends Ability
class_name PlayerMovement

@export_group('Movement')
@export var efficient_bonus :int = 15
@export var run_bonus :int = 20

@onready var stats =L.Beings.INFO["Human"]["SpeedType"]
@onready var speed_jog = stats["Jog"]
@onready var speed_run :int = stats["Run"]
@onready var speed_normal :int = stats["Walk"]
var velocity :Vector2

#func _grandparent_set():
	#grandparent.publisher_one.connect(func(func_name, data:Variant=null):L.Observe.subscribe_to_event(self, func_name, data))

func _physics_process(_delta: float) -> void:                   ## Every physics frame
	if parent.current_state == parent.AbilityStates.IDLING \
	or parent.current_state == parent.AbilityStates.MOVING:
		velocity = Vector2.ZERO                                   ## If current state is Idling or Moving, initialize
		for direction:String in Directon.DIRECTIONS:              ## Cycle through all 4 direction
			if Inputon.look_direction(direction):                  ## JIKL check
				var enput :int = Directon.ENUM_POS[direction]       ## "Enum + Input"
				if enput != grandparent.current_direction:          ## Mostly for animation reasons
					grandparent.current_direction = enput
			velocity = mover(direction)                            ## WASD check
			if velocity != Vector2.ZERO:
				grandparent.velocity_force = velocity
				parent.current_state = parent.AbilityStates.MOVING
				return
		parent.current_state = parent.AbilityStates.IDLING
		grandparent.velocity_force = Vector2.ZERO

func mover(direction :String)->Vector2:
	if Inputon.move(direction):
		velocity = Directon.get_vectors_with_string(direction)
		if Inputon.aim(direction):
			velocity = set_efficiency(speed_run, true)
		elif Inputon.inverse_aim(direction):
			velocity = set_efficiency(speed_normal, false)
		else:
			if Directon.ENUM_POS[direction] == grandparent.current_direction:
				velocity = set_efficiency(speed_jog, true)
			else:
				velocity = set_efficiency(speed_normal, false)
		return velocity
	return Vector2.ZERO

func set_efficiency(speed :int, efficiency :bool)->Vector2:
	parent.is_efficient = efficiency
	return velocity * speed
