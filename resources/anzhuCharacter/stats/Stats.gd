@icon("res://resources/anzhuCharacter/stats/stats.png")
extends CollisionShape2D #Stats.gd

signal is_dead(dead_name :String)
@export_enum("null", "8x8", "10x10", "12x10", "10x12", "12x12") var set_stat_size_option :int = 0: ## Powerful variable change. Affects collision and HP.
	set(value): match value:
				1: stat_size = Vector2i(8, 8)
				2: stat_size = Vector2i(10, 10)
				3: stat_size = Vector2i(12, 10)
				4: stat_size = Vector2i(10, 12)
				5: stat_size = Vector2i(12,12)
var stat_size :Vector2i
@export var needs_only_collider :bool = false ## if false, will unload all unnecessary information
@export var takes_how_much_on_hit :int = 1
@onready var background :ColorRect = $Background
@onready var healthbar :ColorRect = $HealthBar
@onready var parent :Node = get_parent()
@onready var dcolor :String = 'c9c03d'
var max_hp :int

func _ready()->void:
	parent.set_collision_layer_value(5,true)
	if needs_only_collider:
		background.queue_free()
		healthbar.queue_free()
		return
	set_stats()

func set_stats()->void:
	background.size.x = stat_size.x
	background.size.y = stat_size.y
	background.position.x = stat_size.x/-2
	background.position.y = stat_size.y/-2
	max_hp = stat_size.y
	healthbar.size.x = background.size.x
	healthbar.position.x = background.position.x
	healthbar.position.y = abs(background.position.y)

func take_damage(incoming_value :int = takes_how_much_on_hit) -> void:
	healthbar.size.y += incoming_value
	healthbar.position.y -= incoming_value
	printt(max_hp, healthbar.size.y, healthbar.position.y)
	if healthbar.size.y < max_hp:
		return
	if healthbar.position.y > 0:
		return
	parent.change_actions('Dead')
