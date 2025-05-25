extends Area2D
class_name CampFireHeal

var player_in_area = false
@onready var heal_interval :Timer = $HealInterval
@onready var parent = get_parent()

func _ready():
	heal_interval.timeout.connect(distribute_heal)

func heal():
	print('Started Interval')
	heal_interval.start()

func end_heal():
	print('Ended interval')
	heal_interval.stop()

func distribute_heal():
	print('Healed')
	if player_in_area:
		print('Healed Player')
		Signalton.heal_player.emit()


func _on_body_entered(body: Node2D):
	if body is Player:
		player_in_area = true
		if heal_interval.is_stopped() and parent.is_lit:
			heal()


func _on_body_exited(body: Node2D):
	if body is Player:
		player_in_area = false
		end_heal()
