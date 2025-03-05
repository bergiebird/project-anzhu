extends GoalState #hunt.gd

signal boogie_signal(string_name :String)
enum HuntDesire {None, Minimal, Hungry, Unstoppable}
var current_hunt_desire :int = 0
var target :AnzhuCharacter

func enter()->void:
	if Audioton.can_bear_boogie():
		boogie_signal.emit("Hunt")
	target = parent.get_parent().player


func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass

func exit()->void:
	current_hunt_desire = 0


func _on_sight_update(string_name: String) -> void:
	match string_name:
		"OutOfSight": action_transition.emit("Search")
		"Spotted": pass
		_:
			print_rich("[color = red] Unkown String Name: " + string_name + "[/color]")
