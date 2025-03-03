extends GoalState #hunt.gd

enum HuntDesire {None, Minimal, Hungry, Unstoppable}
var current_hunt_desire :int = 0
var target
func on_enter()->void:
	target = parent.get_parent().player


func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass

func on_exit()->void:
	current_hunt_desire = 0


func _on_sight_update(string_name: String) -> void:
	match string_name:
		"OutOfSight": action_transition.emit("Search")
		"Spotted": pass
		_:
			print_rich("[color = red] Unkown String Name: " + string_name + "[/color]")
