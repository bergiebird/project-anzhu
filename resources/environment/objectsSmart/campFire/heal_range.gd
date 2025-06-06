@icon("res://warehouse/icons/misc/icons8-health-100.png")
extends Area2D
class_name HealingArea

var player_in_area :bool = false

@onready var heal_interval :Timer = $HealInterval
@onready var parent = get_parent()

func _ready():
	heal_interval.timeout.connect(distribute_heal)
	body_entered.connect(_on_player_entering_area)
	body_exited.connect(_on_player_exiting_area)
	parent.get_node('Fire').visibility_changed.connect(_on_fire_visibility_changed)

func distribute_heal():
	if player_in_area:
		Signalton.heal_player.emit()

func _on_player_entering_area(body: Node2D):
	if body is Player:
		player_in_area = true
		if heal_interval.is_stopped() and parent.fire_light.visible:
			heal_interval.start()

func _on_player_exiting_area(body: Node2D):
	if body is Player:
		player_in_area = false
		heal_interval.stop()

func _on_fire_visibility_changed():
	if parent.fire_anim.visible:
		heal_interval.start()
	else:
		heal_interval.stop()
