@icon("res://resources/anzhuBeing/mask/mask.png")
class_name Mask extends CollisionShape2D #Mask.gd

## Powerful variable change. Affects collision and HP.
@export_enum("null", "8x8", "10x10", "12x10", "10x12", "12x12") var set_mask_dimensions :int = 0:
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
@export var damage_recieved :int = 1
@export var background_color :Color = Swatchton.BLACK
@export var healthbar_color :Color = Swatchton.RED_TOMATO
var mask_dimensions :Vector2
var max_hp :int
var background :ColorRect
var healthbar :ColorRect
@onready var collision_shape :RectangleShape2D = shape
@onready var parent :CollisionObject2D = get_parent()

func _ready():
	_setup_basics()            # Ensure the misc properties are set
	visible = true
	if has_background: _establish_background()
	if has_healthbar: _establish_healthbar()

func _setup_basics():
	if parent is Player:                                               # Player specific changes
		parent.set_collision_layer_value(5,true)                        # We also handle the player's collider from here.
	collision_shape.size.x = snapped(mask_dimensions.x - 0.1, 0.01)    # Algorithm to set the dimensions
	collision_shape.size.y = snapped(mask_dimensions.y - 0.1, 0.01)    # It is just a little smaller than advertised.

func _establish_background():
		background = ColorRect.new()                  # Its Alive!
		background.color = background_color           # Exported color set as background
		background.size.x = mask_dimensions.x         # Size of the image set here
		background.size.y = mask_dimensions.y
		background.position.x = mask_dimensions.x/-2  # Position set as per the size
		background.position.y = mask_dimensions.y/-2
		add_child(background)                         # Setup for ColorRect background done! instaniate

func _establish_healthbar():
		healthbar = ColorRect.new()                        # Yess! Yesss, more power!
		healthbar.color = healthbar_color                  # Set the color of the healthbar via whats set in export
		max_hp = int(mask_dimensions.y)                    # Instantiate max_hp's value for intuitivity in another method
		healthbar.size.x = background.size.x               # size is set to be as wide as the collision box. Y value is ignored
		healthbar.position.x = background.position.x       # Position the healthbar appropriately.
		healthbar.position.y = abs(background.position.y)  # You know, I forget why I needed to absolute it. But it works!
		add_child(healthbar)                               # Add

func jumping(needs_inverse:bool)->void:                  # needs inverse because the signal incoming says is_jumping = true
	visible=!needs_inverse                                # and we want to say if is_jumping = true, set_visibility(false)

func was_struck(incoming_value :int = damage_recieved):
		healthbar.size.y += incoming_value                    # The incoming value will raise the healthbar by that many pixels
		healthbar.position.y -= incoming_value                # The position needs to compensate
		check_if_should_start_death()

func check_if_should_start_death():
	if healthbar.size.y >= max_hp and healthbar.position.y <= 0:
		parent.publisher_null.emit('has_died')

#region DEBUG
@export var debug :bool = false
@export var dcolor :String = 'c9c03d'
#endregion
