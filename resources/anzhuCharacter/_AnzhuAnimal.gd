class_name AnzhuAnimal extends AnzhuCharacter #_AnzhuAnimal.gd
signal striking()

enum AnimalGoals {GetSleep,FindFood,FindWater,Nothing,Hunt,StayWithHerd,FleeWithHerd, WanderWithHerd}
enum AnimalActions {Idle,Sit,Hit,Wander,Chase,Dead,Search,Charge,Sleep,Graze,Dash}
#@export var corpse_script :Script = load("res://resources/corpse/Corpse.gd")
@export var starting_goal :AnimalGoals = AnimalGoals.Nothing
var goals :Node
var corpse :Area2D
var player :Player
var current_speed :int
var current_action :AnimalActions
var current_goal :AnimalGoals
var old_goal_name :String
var old_action_name :String
var hurt_box :Area2D

func character_ready()->void:
	init_scenes_nodes()
	character_signal_connector()
	animal_ready()
	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is State and not grandchild.is_connected(&"action_transition", change_actions):
				grandchild.action_transition.connect(change_actions)
	change_goals(AnimalGoals.keys()[starting_goal])
	hurt_box = scenes_nodes['HurtBox']

func character_process(delta:float)->void:
	animal_process(delta)

func character_signal_connector()->void:
	striking.connect(animal_strike)

func init_scenes_nodes()->void:
	player = scenes_nodes['Player']
	goals = scenes_nodes['AnimalGoals']
	mask = scenes_nodes['Mask']
	current_action = AnimalActions.Idle
	add_to_group('animal')

func change_actions(new_action_name :String)->void:
	if new_action_name == AnimalActions.keys()[current_action]:
		return
	match new_action_name:
		"Idle":   current_action = AnimalActions.Idle
		"Sit":    current_action = AnimalActions.Sit
		"Hit":    current_action = AnimalActions.Hit
		"Wander": current_action = AnimalActions.Wander
		"Chase":  current_action = AnimalActions.Chase
		"Dead":
			print('dead recieved')
			current_action = AnimalActions.Dead
		"Search": current_action = AnimalActions.Search
		"Charge": current_action = AnimalActions.Charge
		"Sleep":  current_action = AnimalActions.Sleep
		"Graze":  current_action = AnimalActions.Graze
		"Dash":   current_action = AnimalActions.Dash
		_:        return
	anim.on_action_transition(new_action_name)
	old_action_name = new_action_name

func change_goals(new_goal_name :String)->void:
	if new_goal_name == AnimalGoals.keys()[current_goal]:
		return
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
	change_actions("Hit")
	was_hit.emit()

func uninjur()->void:
	is_injured = false
	is_stunned = false

func stop_in_tracks(unused_string)->void:
	velocity = Vector2.ZERO


###VIRTUALS###
func animal_ready()->void:pass
func animal_process(delta:float)->void: pass
func animal_strike()->void:pass
###VIRTUALS###
