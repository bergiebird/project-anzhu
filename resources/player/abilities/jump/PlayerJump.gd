@icon("res://resources/player/abilities/jump/icons8-track-and-field-skin-type-1-100.png")
extends Ability #PlayerJump.gd
@export var jump_time :float = 1.3
@export var jump_distance :float = 1.5
@onready var mask :CollisionShape2D = %Mask
@onready var grandparent :Player = get_parent().get_parent()
@onready var D :Directon = Directon
@onready var I :Object = Input
@onready var timer :Timer = $Timer
@onready var character_directions_bible :Dictionary = D.character_directions_bible
const TILE_SIZE :int = 8
var snow_tracker_node :Node
var elev :TileMapLayer
var is_jump_initiated :bool = false

func _ready() -> void:
	timer.wait_time = jump_time
	timer.timeout.connect(jumping_attributes)

func start_jump()->void:
	if I.is_action_just_pressed('jump') and parent.can_jump:
		is_jump_initiated = true
	if I.is_action_just_released("jump") and is_jump_initiated:
		var jump_direction = character_directions_bible[D.direction_priority[D.looking_where]]['jump']
		var current_coordinates :Vector2 = elev.local_to_map(elev.to_local(grandparent.global_position))
		var target_coordinates :Vector2 = jump_direction*jump_distance + current_coordinates
		print(current_coordinates)
		print(target_coordinates)
		var current_elevation :int = elev.get_cell_tile_data(current_coordinates).get_custom_data_by_layer_id(0)
		var target_elevation :int = elev.get_cell_tile_data(target_coordinates).get_custom_data_by_layer_id(0)
		if current_elevation >= target_elevation:
			jumping_attributes(false)
			if jump_direction.x == 0:
				create_tween().tween_property(grandparent, 'global_position', Vector2(
					grandparent.global_position.x ,grandparent.global_position.y + (jump_direction.y * TILE_SIZE *jump_distance)), jump_time)
			elif jump_direction.y == 0:
				create_tween().tween_property(grandparent, 'global_position',Vector2(
					grandparent.global_position.x + (jump_direction.x * TILE_SIZE * jump_distance) ,grandparent.global_position.y), jump_time)
			else:
				return
			timer.start()

func jumping_attributes(is_jump_active :bool = true)->void:
	grandparent.set_collision_layer_value(1, is_jump_active)
	grandparent.set_collision_mask_value(1, is_jump_active)
	snow_tracker_node.can_make_tracks = is_jump_active
	mask.visible = is_jump_active
