extends CollisionShape2D
class_name Mask

#region    #============================================================# VARIABLES

@export_multiline var description: String = """NARP"""
enum MaskDims {NULL, _08x08, _10x10, _10x12, _12x10, _12x12, _07x07}
## Powerful variable change. Affects collision and HP.
@export var set_mask_dimensions: MaskDims = 0:
	set(value):
		match value:
			MaskDims.NULL:   printerr('mask dims not set for ' + parent.name)
			MaskDims._08x08: mask_dimensions = Vector2(8, 8)
			MaskDims._10x10: mask_dimensions = Vector2(10, 10)
			MaskDims._12x10: mask_dimensions = Vector2(12, 10)
			MaskDims._10x12: mask_dimensions = Vector2(10, 12)
			MaskDims._12x12: mask_dimensions = Vector2(12,12)
			MaskDims._07x07: mask_dimensions = Vector2(6,6)

@export var has_healthbar: bool = true
@export var has_background: bool = true
@export var damage_recieved: int = 1
@export var background_color: Color = Lib.Palette.BLACK
@export var healthbar_color: Color = Lib.Palette.RED_TOMATO

var mask_dimensions: Vector2
var max_hp: int
var healthbar: ColorRect
var minimum_hp_size: float
var minimum_hp_position: float
var enable_click: bool = false:
	set(v):
		enable_click = v
		if enable_click:
			Inputon.set_cursor_to_ibeam()  # on_entering the sign's area
		else:
			Inputon.set_cursor_to_point()  # on_exiting the sign's area //DEFAULT

@onready var parent :CollisionObject2D = get_parent()

#endregion
#region    #============================================================# FUNCTIONS

func _ready():
	_setup_basics()                                            # Ensure the misc properties are set
	if has_background:
		_establish_background()
	if has_healthbar:
		_establish_healthbar()
	if parent is AnzhuBeing:
		(func(): parent.publish_event.emit("mask_dimensions_of_self",mask_dimensions)).call_deferred()
		if parent is Player:
			Sgnl.heal_player.connect(_heal_player)

func initial_output(new_description: String):
	if new_description:
		description = new_description

func _setup_basics():
	visible = true
	shape.size.x = snapped(mask_dimensions.x - 0.1, 0.01)  # Algorithm to set the dimensions
	shape.size.y = snapped(mask_dimensions.y - 0.1, 0.01)  # It is just a little smaller than advertised.

func _establish_background():
	var background: ColorRect = ColorRect.new()                             # Its Alive!
	background.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	background.set_default_cursor_shape(Control.CURSOR_IBEAM)
	background.color = background_color                       # Exported color set as background
	background.size.x = mask_dimensions.x                     # Size of the image set here
	background.size.y = mask_dimensions.y
	background.position.x = mask_dimensions.x/-2              # Position set as per the size
	background.position.y = mask_dimensions.y/-2
	background.mouse_entered.connect(func(): enable_click = true)
	background.mouse_exited.connect(func(): enable_click = false)
	add_child(background)                                     # Setup for ColorRect background done! instaniate

func _establish_healthbar():
	healthbar = ColorRect.new()                               # Yess! Yesss, more power!
	healthbar.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	healthbar.set_default_cursor_shape(Control.CURSOR_IBEAM)
	healthbar.color = healthbar_color                         # Set the color of the healthbar via whats set in export
	max_hp = int(mask_dimensions.y)                           # Instantiate max_hp's value for intuitivity in another method
	minimum_hp_size = mask_dimensions.y
	healthbar.size.x = mask_dimensions.x                      # size is set to be as wide as the collision box. Y value is ignored
	minimum_hp_position = abs(mask_dimensions.y/-2)
	healthbar.position.x = mask_dimensions.x/-2               # Position the healthbar appropriately.
	healthbar.position.y = abs(mask_dimensions.y/-2)          # You know, I forget why I needed to absolute it. But it works!
	add_child(healthbar)                                      # Add

func _input(event: InputEvent):
	if enable_click:
		if event is InputEventMouseButton:
				Sgnl.update_console.emit(description)

func jumping(needs_inverse: bool):
	visible=!needs_inverse

func _heal_player():
	if parent is Player:
		if healthbar.size.y > 0.0 and healthbar.position.y < minimum_hp_position:
			healthbar.size.y -= 1                    # The incoming value will raise the healthbar by that many pixels
			healthbar.position.y += 1                # The position needs to compensate
			if has_node("FullHP"):
				if healthbar.size.y == 0.0 and healthbar.position.y == minimum_hp_position:
					$FullHP.play()

func was_struck(incoming_value: int = damage_recieved):
	healthbar.size.y += incoming_value                    # The incoming value will raise the healthbar by that many pixels
	healthbar.position.y -= incoming_value                # The position needs to compensate
	check_if_should_start_death()

func check_if_should_start_death():
	if healthbar.size.y >= max_hp and healthbar.position.y <= 0:
		parent.publish_event.emit('has_died')

#endregion
@export_group("Debug")
#region
@export var debug :bool = false
@export var dcolor :String = 'c9c03d'

#endregion
