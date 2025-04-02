@icon("res://resources/anzhuCharacter/mask/mask.png")
extends CollisionShape2D #Mask.gd
@export_enum("null", "8x8", "10x10", "12x10", "10x12", "12x12") var set_mask_dimensions :int = 0: ## Powerful variable change. Affects collision and HP.
	set(value): match value:
		0: print('mask dims not set for ' + get_parent().self.name)
		1: mask_dimensions = Vector2i(8, 8)
		2: mask_dimensions = Vector2i(10, 10)
		3: mask_dimensions = Vector2i(12, 10)
		4: mask_dimensions = Vector2i(10, 12)
		5: mask_dimensions = Vector2i(12,12)
var mask_dimensions :Vector2i
@export var release_healthbar :bool = false
@export var release_background :bool = false
@export var takes_how_much_on_hit :int = 1
@onready var background :ColorRect = $Background
@onready var healthbar :ColorRect = $HealthBar
@onready var parent :Node = get_parent()
@onready var dcolor :String = 'c9c03d'
var max_hp :int

func _ready()->void:
	parent.set_collision_layer_value(5,true)
	if release_background: background.queue_free()
	else:
		background.size.x = mask_dimensions.x
		background.size.y = mask_dimensions.y
		background.position.x = mask_dimensions.x/-2
		background.position.y = mask_dimensions.y/-2
	if release_healthbar: healthbar.queue_free()
	else:
		max_hp = mask_dimensions.y
		healthbar.size.x = background.size.x
		healthbar.position.x = background.position.x
		healthbar.position.y = abs(background.position.y)

func take_damage(incoming_value :int = takes_how_much_on_hit) -> void:
	healthbar.size.y += incoming_value
	healthbar.position.y -= incoming_value
	check_if_dead()

func check_if_dead()->void:
	if healthbar.size.y >= max_hp and healthbar.position.y <= 0: 
		parent.has_died.emit()

func signal_connector()->void:
	parent.was_hit.connect(take_damage)
