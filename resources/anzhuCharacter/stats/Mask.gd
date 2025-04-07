@icon("res://resources/anzhuCharacter/mask/mask.png")
extends CollisionShape2D #Mask.gd

@export_enum("null", "8x8", "10x10", "12x10", "10x12", "12x12") var set_mask_dimensions :int = 0: ## Powerful variable change. Affects collision and HP.
	set(value):
		match value:
			0: print('mask dims not set for ' + get_parent().self.name)
			1: mask_dimensions = Vector2(8, 8)
			2: mask_dimensions = Vector2(10, 10)
			3: mask_dimensions = Vector2(12, 10)
			4: mask_dimensions = Vector2(10, 12)
			5: mask_dimensions = Vector2(12,12)
@export var has_healthbar :bool = true
@export var has_background :bool = true
@export var takes_how_much_on_hit :int = 1
var mask_dimensions :Vector2
var max_hp :int ##This gets established by set_mask_dimensions in establish_healthbar()
@onready var parent :Node = get_parent()
@onready var background :ColorRect = $Background
@onready var healthbar :ColorRect = $HealthBar

func _ready()->void:
	setup_basics()
	establish_background()
	establish_healthbar()

func setup_basics()->void:
	parent.set_collision_layer_value(5,true)
	shape.size.x = snapped(mask_dimensions.x - 0.05, 0.01)
	shape.size.y = snapped(mask_dimensions.y - 0.05, 0.01)
	printt(shape.size, parent.name)

func establish_background()->void:
	if has_background:
		parent.was_struck.connect(take_damage)
		background.size.x = mask_dimensions.x
		background.size.y = mask_dimensions.y
		background.position.x = mask_dimensions.x/-2
		background.position.y = mask_dimensions.y/-2
	else:
		background.queue_free()

func establish_healthbar()->void:
	if has_healthbar:
		max_hp = mask_dimensions.y
		healthbar.size.x = background.size.x
		healthbar.position.x = background.position.x
		healthbar.position.y = abs(background.position.y)
	else:
		healthbar.queue_free()

###
##FUNCTIONS
###
func take_damage(incoming_value :int = takes_how_much_on_hit) -> void:
	healthbar.size.y += incoming_value
	healthbar.position.y -= incoming_value
	check_if_dead()

func check_if_dead()->void:
	if healthbar.size.y >= max_hp and healthbar.position.y <= 0:
		parent.has_died.emit()

###
##DEBUG
###
@onready var dcolor :String = 'c9c03d'
