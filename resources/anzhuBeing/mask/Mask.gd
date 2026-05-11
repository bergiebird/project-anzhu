extends CollisionShape2D
class_name Mask

#region    #============================================================# VARIABLES

enum MaskDims {
	NULL,
	_08x08,
	_10x10,
	_10x12,
	_12x10,
	_12x12,
	_07x07,
}

## Powerful variable change. Affects collision and HP.
@export_multiline var description: String = """NARP"""
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
var background: ColorRect
var enable_click: bool = false:
	set(v):
		enable_click = v
		if enable_click:
			Inputon.set_cursor_to_ibeam()  # on_entering the sign's area
		else:
			Inputon.set_cursor_to_point()  # on_exiting the sign's area //DEFAULT
var rotation_amount: float = 0.01
var rotation_crement: float = 0.003

@onready var parent: CollisionObject2D = get_parent()

#region    #============================================================# FUNCTIONS

func _ready():
	_setup_basics()                                            # Ensure the misc properties are set
	if has_background:
		_establish_background()
	if has_healthbar:
		_establish_healthbar()
	if parent is AnzhuBeing:
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
	background = ColorRect.new()                             # Its Alive!
	background.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	background.set_default_cursor_shape(Control.CURSOR_IBEAM)
	background.color = background_color                       # Exported color set as background
	background.size.x = mask_dimensions.x                     # Size of the image set here
	background.size.y = mask_dimensions.y
	background.position.x = mask_dimensions.x/-2              # Position set as per the size
	background.position.y = mask_dimensions.y/-2
	background.pivot_offset = -background.position
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
	healthbar.pivot_offset = -healthbar.position
	add_child(healthbar)                                      # Add


func _input(event: InputEvent) -> void:
	if enable_click:
		if event is InputEventMouseButton:
			if parent is AnzhuBeing:
				description = parent.visual_description
			Sgnl.update_console.emit(description)


func _heal_player() -> void:
	if parent is Player:
		if healthbar.size.y > 0.0 and healthbar.position.y < minimum_hp_position:
			healthbar.size.y -= 1                    # The incoming value will raise the healthbar by that many pixels
			healthbar.position.y += 1                # The position needs to compensate
			rotation_amount -= rotation_crement
			if has_node("FullHP"):
				if healthbar.size.y == 0.0 and healthbar.position.y == minimum_hp_position:
					$FullHP.play()


func was_struck(incoming_value: int = damage_recieved) -> void:
	if !has_background:
		return

	healthbar.size.y += incoming_value                    # The incoming value will raise the healthbar by that many pixels
	healthbar.position.y -= incoming_value                # The position needs to compensate
	_animate()
	if healthbar.size.y >= max_hp and healthbar.position.y <= 0:
		parent.has_died.emit()
		#parent.publish_event.emit('has_died')


func _animate():
	var tween: Tween = create_tween()
	var htween: Tween = create_tween()
	htween.tween_property(healthbar, ^"rotation", rotation_amount, 0.1).set_trans(Tween.TRANS_BOUNCE)
	await tween.tween_property(background, ^"rotation", rotation_amount, 0.1).set_trans(Tween.TRANS_BOUNCE).finished
	var _tween: Tween = create_tween()
	var _htween: Tween = create_tween()
	_htween.tween_property(healthbar, ^"rotation", -2*rotation_amount, 0.2).set_trans(Tween.TRANS_BOUNCE)
	await _tween.tween_property(background, ^"rotation", -2*rotation_amount, 0.2).set_trans(Tween.TRANS_BOUNCE).finished
	var __tween: Tween = create_tween()
	var __htween: Tween = create_tween()
	__htween.tween_property(healthbar, ^"rotation", 0.0, 0.1).set_trans(Tween.TRANS_BOUNCE)
	__tween.tween_property(background, ^"rotation", 0.0, 0.1).set_trans(Tween.TRANS_BOUNCE)
	rotation_amount += rotation_crement
	await get_tree().create_timer(0.5).timeout
	tween.kill()
	htween.kill()
	_tween.kill()
	_htween.kill()
	__tween.kill()
	__htween.kill()



func _on_jump_ended_jump() -> void:
	visible = true


func _on_jump_started_jump() -> void:
	visible = false
