extends Node2D

@onready var ray_north :RayCast2D = $RayNorth
@onready var ray_south :RayCast2D = $RaySouth
@onready var ray_east  :RayCast2D = $RayEast
@onready var ray_west  :RayCast2D = $RayWest

func mask_dimensions_of_self(mask_dimensions :Vector2):
	ray_north.target_position.y = mask_dimensions.y
