extends GoalState #GoalHunt.gd

signal boogie_signal(string_name :String)
enum HuntDesire {None, Minimal, Hungry, Unstoppable}
var current_hunt_desire :int = 0
var target :AnzhuCharacter
@onready var A:Audioton = Audioton

func enter()->void:
	if A.can_bear_boogie():
		boogie_signal.emit("Hunt")
	target = parent.get_parent().player
	action_transition.emit('Chase')

func update(_delta:float)->void:
	pass

func physics_update(_delta:float)->void:
	pass

func exit()->void:
	current_hunt_desire = 0


func _on_sight_update(string_name: String) -> void:
	match string_name:
		"OutOfSight": pass #action_transition.emit("Search")
		"Spotted": pass
		_:
			print_rich("[color = red] Unkown String Name: " + string_name + "[/color]")
