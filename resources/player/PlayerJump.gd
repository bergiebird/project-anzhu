@icon("res://warehouse/_icons/misc/icons8-caps-lock-on-100.png")
extends Ability #PlayerJump.gd

@onready var stats :CollisionShape2D = %Stats
@onready var grandparent :Player = get_parent().get_parent()
@onready var directon :Directon = Directon
@onready var character_directions_bible :Dictionary = directon.character_directions_bible
var elev :TileMapLayer
@onready var InputClass :Object = Input


func start_jump()->void:
	if InputClass.is_action_just_pressed('jump') and parent.can_jump:
		print(get_elevation(elev.local_to_map(elev.to_local(grandparent.global_position)))) # get tile position
	if InputClass.is_action_just_released("jump") and parent.can_jump:
		stats.visible = false
		var jump_direction = character_directions_bible\
			[directon.direction_priority[directon.looking_where]]["jump"]
		grandparent.velocity = 1500.0 * jump_direction
		await get_tree().create_timer(1.0).timeout
		stats.visible = true


func get_elevation(target_tile :Vector2i)->int:
	return elev.get_cell_tile_data(target_tile).get_custom_data_by_layer_id(0)

func jump_stat_delivery(elevation_node :TileMapLayer)->void:
	elev = elevation_node
