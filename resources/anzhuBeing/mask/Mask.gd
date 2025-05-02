@icon("res://resources/anzhuBeing/mask/mask.png")
extends CollisionShape2D #Mask.gd
@export_enum("null", "8x8", "10x10", "12x10", "10x12", "12x12") var set_mask_dimensions :int = 0: ## Powerful variable change. Affects collision and HP.
	set(value):
		match value:
			0: print('mask dims not set for ' + parent.name)
			1: mask_dimensions = Vector2(8, 8)
			2: mask_dimensions = Vector2(10, 10)
			3: mask_dimensions = Vector2(12, 10)
			4: mask_dimensions = Vector2(10, 12)
			5: mask_dimensions = Vector2(12,12)
@export var has_healthbar :bool = true
@export var has_background :bool = true
@export var takes_how_much_on_hit :int = 1
@export var background_color :Color = Swatchton.BLACK
@export var healthbar_color :Color = Swatchton.RED_TOMATO
var mask_dimensions :Vector2
var max_hp :int
var abilities :Abilities
@onready var parent :Node = get_parent()
@onready var background :ColorRect = ColorRect.new()
@onready var healthbar :ColorRect = ColorRect.new()
@onready var collision_shape :RectangleShape2D = shape

func _ready()->void:
	setup_basics()
	establish_background()
	establish_healthbar()
	add_nodes()

func setup_basics()->void:
	if parent.has_node("Abilities"):
		abilities = parent.get_node('Abilities')
		Debuggerton.signal_checker([
			abilities.jumping.connect(func(needs_inverse:bool)->void: visible=!needs_inverse)
		])
	if parent.has_method("set_collision_layer_value"):
		parent.set_collision_layer_value(5,true)
	collision_shape.size.x = snapped(mask_dimensions.x - 0.1, 0.01)
	collision_shape.size.y = snapped(mask_dimensions.y - 0.1, 0.01)

func establish_background()->void:
	if has_background:
		background.color = background_color
		if parent.has_signal('was_struck'):
			Debuggerton.signal_checker([
				parent.was_struck.connect(take_damage)
			], debug)
		background.size.x = mask_dimensions.x
		background.size.y = mask_dimensions.y
		background.position.x = mask_dimensions.x/-2
		background.position.y = mask_dimensions.y/-2
	else:
		background.queue_free()

func establish_healthbar()->void:
	if has_healthbar:
		healthbar.color = healthbar_color
		max_hp = int(mask_dimensions.y)
		healthbar.size.x = background.size.x
		healthbar.position.x = background.position.x
		healthbar.position.y = abs(background.position.y)
	else:
		healthbar.queue_free()

func add_nodes()->void:
	add_child(background)
	add_child(healthbar)

###
##FUNCTIONS
###
func take_damage(incoming_value :int = takes_how_much_on_hit) -> void:
	healthbar.size.y += incoming_value
	healthbar.position.y -= incoming_value
	if healthbar.size.y >= max_hp and healthbar.position.y <= 0:
		parent.has_died.emit()

###
##DEBUG
###
@export var debug :bool = false
@export var dcolor :String = 'c9c03d'
