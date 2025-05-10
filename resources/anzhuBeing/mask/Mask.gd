@icon("res://resources/anzhuBeing/mask/mask.png")
class_name Mask extends CollisionShape2D #Mask.gd

signal has_died
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
@export var takes_how_much_on_hit :int = 1
@export var background_color :Color = Swatchton.BLACK
@export var healthbar_color :Color = Swatchton.RED_TOMATO
var mask_dimensions :Vector2
var max_hp :int
var abilities :Abilities
@onready var parent :CollisionObject2D = get_parent()
var background :ColorRect
var healthbar :ColorRect
@onready var collision_shape :RectangleShape2D = shape

func _ready():
	setup_basics()            # Ensure the misc properties are set
	establish_background()
	establish_healthbar()

func setup_basics():
	if parent is Player:                                               # Player specific changes
		abilities = parent.get_node('Abilities')                        # We're mostly interested in the Jump
		abilities.jumping.connect(update_mask_visibility)               # This is where we turn the mask off while jumping
		parent.set_collision_layer_value(5,true)                        # We also handle the player's collider from here.
	collision_shape.size.x = snapped(mask_dimensions.x - 0.1, 0.01)    # Algorithm to set the dimensions
	collision_shape.size.y = snapped(mask_dimensions.y - 0.1, 0.01)    # It is just a little smaller than advertised.

func establish_background():
	if has_background:                               # If export is set to True
		background = ColorRect.new()                  # Its Alive!
		background.color = background_color           # Exported color set as background
		background.size.x = mask_dimensions.x         # Size of the image set here
		background.size.y = mask_dimensions.y
		background.position.x = mask_dimensions.x/-2  # Position set as per the size
		background.position.y = mask_dimensions.y/-2
		if parent is AnzhuBeing:
			parent.was_struck.connect(take_damage)     # Setup if the player uses the background as a healthbar
		add_child(background)                         # Setup for ColorRect background done! instaniate

func establish_healthbar():
	if has_healthbar:
		healthbar = ColorRect.new()                        # Yess! Yesss, more power!
		healthbar.color = healthbar_color                  # Set the color of the healthbar via whats set in export
		max_hp = int(mask_dimensions.y)                    # Instantiate max_hp's value for intuitivity in another method
		healthbar.size.x = background.size.x               # size is set to be as wide as the collision box. Y value is ignored
		healthbar.position.x = background.position.x       # Position the healthbar appropriately.
		healthbar.position.y = abs(background.position.y)  # You know, I forget why I needed to absolute it. But it works!
		add_child(healthbar)                               # Add

func update_mask_visibility(needs_inverse:bool)->void:   # needs inverse because the signal incoming says is_jumping = true
	visible=!needs_inverse                                # and we want to say if is_jumping = true, set_visibility(false)

func take_damage(incoming_value :int = takes_how_much_on_hit):
	if has_healthbar:                                               # This handles incrementing the healthbar
		healthbar.size.y += incoming_value                           # The incoming value will raise the healthbar by that many pixels
		healthbar.position.y -= incoming_value                       # The position needs to compensate
		if healthbar.size.y >= max_hp and healthbar.position.y <= 0: # Now we check to see if the player has died
			parent.has_died.emit()                                    # And if so, we signal to the rest of the scene.

#region DEBUG
@export var debug :bool = false
@export var dcolor :String = 'c9c03d'
#endregion
