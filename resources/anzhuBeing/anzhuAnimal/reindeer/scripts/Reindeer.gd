@icon("res://resources/anzhuAnimal/reindeer/reindeer.png")
class_name Reindeer extends AnzhuAnimal #Reindeer.gd
var herd_members :Array = []
var preferred_distance :int = 50
var min_distance :int = 20
var max_distance :int = 100

#func _process(_delta :float)->void:
	#update_herd_awareness()
#
#func update_herd_awareness()->void:
	##herd_members = get_tree().get_nodes_in_group('reindeer')
	#herd_members.erase(self)

func on_gunshot():
	if player and global_position.distance_to(player.global_position) < 200:
		publish_event.emit("change_goals", "FleeFromThreat")
		for member :Reindeer in herd_members:
			if member.global_position.distance_to(global_position) < 100:
				member.change_goals('FleeFromThreat')








###
## DEBUG
###
func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/reindeer/reindeer.png[/img]"
		print_rich(debug_icon)
