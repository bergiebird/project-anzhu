@icon("res://resources/reindeer/reindeer.png")
class_name Reindeer extends AnzhuAnimal #Reindeer.gd

var herd_members :Array = []
var preferred_distance :int = 50
var min_distance :int = 20
var max_distance :int = 100

func animal_ready()->void:
	add_to_group("reindeer")
	Signalton.gunshot.connect(on_gunshot)

func _process(delta: float) -> void:
	update_herd_awareness()

func update_herd_awareness()->void:
	herd_members = get_tree().get_nodes_in_group('reindeer')
	herd_members.erase(self)

func on_gunshot()->void:
	if player and global_position.distance_to(player.global_position) < 200:
		change_goals('FleeFromThreat')
		for member in herd_members:
			if member.global_position.distance_to(global_position) < 100:
				member.change_goals('FleeFromThreat')
