extends GoalState #GoalHunt.gd

enum HuntDesire {None, Minimal, Hungry, Unstoppable}
var current_hunt_desire :int = 0
var target :AnzhuBeing

func enter()->void:
	if grandparent.is_in_group('Bear'):
		Audioton.can_bear_boogie(grandparent)
	Debuggerton.signal_checker([
		Libraryton.player_reference.connect(func(ref:Player)->void: target = ref)])
	grandparent.change_actions('Chase')

func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass

func exit()->void:
	current_hunt_desire = 0


func _on_spotted(string_name: String) -> void:
	match string_name:
		"OutOfSight":
			pass
		"Spotted":
			pass
		_:
			print_rich("[color = red] Unkown String Name: " + string_name + "[/color]")
