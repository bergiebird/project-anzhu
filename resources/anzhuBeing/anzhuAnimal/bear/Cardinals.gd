extends Node2D

signal collision_with_wall

var all_rays: Array[RayCast2D]

@onready var ray_north: RayCast2D = $RayNorth
@onready var ray_south: RayCast2D = $RaySouth
@onready var ray_east: RayCast2D = $RayEast
@onready var ray_west: RayCast2D = $RayWest


func _ready() -> void:
	all_rays = [ray_east, ray_north, ray_south, ray_west]
	for ray in all_rays:
		ray.target_position *= 3.0


func _physics_process(_delta: float) -> void:
	for ray in all_rays:
		#ray.force_raycast_update()
		if ray.is_colliding():
			print("===============RAY IS COLLIDING")
