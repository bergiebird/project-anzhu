class_name AnzhuAnimal extends AnzhuCharacter #_AnzhuAnimal.gd

enum AnimalGoals {GetSleep,FindFood,FindWater,Nothing,Hunt,StayWithHerd,FleeWithHerd, WanderWithHerd}
enum AnimalActions {Idle,Sit,Hit,Wander,Chase,Dead,Search,Charge,Sleep,Graze,Dash}

@export var starting_goal :AnimalGoals = AnimalGoals.Nothing
@export_group("Debug")
@export var debug_actions :bool = false
@export var debug_goals :bool = false
var goals :Node
var corpse :Area2D
var player :Player
var current_speed :int
var current_action :AnimalActions
var current_goal :AnimalGoals
var old_goal_name :String
var old_action_name :String


func ready()->void:
	init_scenes_nodes()
	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is State and not grandchild.is_connected(&"action_transition", change_actions):
				grandchild.action_transition.connect(change_actions)
	change_goals(AnimalGoals.keys()[starting_goal])
	animal_ready()
func animal_ready()->void:pass

func init_scenes_nodes()->void:
	player = scenes_nodes['Player']
	goals = scenes_nodes['AnimalGoals']
	stats = scenes_nodes['Stats']
	corpse = scenes_nodes['Corpse']
	current_action = AnimalActions.Idle
	add_to_group('animal')

func change_actions(new_action_name :String)->void:
	if new_action_name == AnimalActions.keys()[current_action]: return
	elif debug_actions:
		print_rich("""
		[table=3][cell][color=orange]%s[/color][/cell][cell][color=yellow]  ACTION: %s[/color] → [color=lime]%s[/color][/cell][/table]""" %
		[self.name, old_action_name, new_action_name])
	match new_action_name:
		"Idle":   current_action = AnimalActions.Idle
		"Sit":    current_action = AnimalActions.Sit
		"Hit":    current_action = AnimalActions.Hit
		"Wander": current_action = AnimalActions.Wander
		"Chase":  current_action = AnimalActions.Chase
		"Dead":   current_action = AnimalActions.Dead
		"Search": current_action = AnimalActions.Search
		"Charge": current_action = AnimalActions.Charge
		"Sleep":  current_action = AnimalActions.Sleep
		"Graze": current_action = AnimalActions.Graze
		"Dash": current_action = AnimalActions.Dash
		_: return
	anim.on_action_transition(new_action_name)
	old_action_name = new_action_name


func change_goals(new_goal_name :String)->void:
	if new_goal_name == AnimalGoals.keys()[current_goal]:
		return
	elif debug_goals:
		print_rich("""
		[table=3][cell][color=orange]%s[/color][/cell][cell][b]  GOAL:[/b] [color=#AAAAAA]%s[/color] → [color=white]%s[/color][/cell][/table]"""
		% [self.name, old_goal_name, new_goal_name])
	match new_goal_name:
		"Nothing":   current_goal = AnimalGoals.Nothing
		"GetSleep":  current_goal = AnimalGoals.GetSleep
		"FindFood":  current_goal = AnimalGoals.FindFood
		"Hunt":      current_goal = AnimalGoals.Hunt
		"StayWithHerd": current_goal = AnimalGoals.StayWithHerd
		"FleeWithHerd": current_goal = AnimalGoals.FleeWithHerd
		"WanderWithHerd": current_goal = AnimalGoals.WanderWithHerd
		_: return
	goals.on_goal_transition(new_goal_name)
	old_goal_name = new_goal_name

func got_hit()->void:
	is_stunned = true
	is_injured = true
	change_actions("Hit")

func end_of_life()->void:
	var new_corpse :Area2D = Area2D.new()
	var corpse_script :Object = load("res://resources/corpse/Corpse.gd")
	new_corpse.set_script(corpse_script)
	new_corpse.global_position = global_position
	remove_child(corpse)
	remove_child(stats)
	remove_child(anim)
	new_corpse.add_child(stats)
	new_corpse.add_child(anim)
	for child in anim.get_children():
		child.queue_free()
	anim.set_script(null)
	anim.play('Corpse')
	parent.add_child(new_corpse)
	print('did it work')
	new_corpse.allow_pickup()
	animal_end_of_life()
	queue_free()
func animal_end_of_life()->void:pass
