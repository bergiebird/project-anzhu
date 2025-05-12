class_name AnzhuAnimal extends AnzhuBeing #_AnzhuAnimal.gd
enum AnimalGoals {GetSleep,FindFood,FindWater,Nothing,Hunt,StayWithHerd,FleeWithHerd, WanderWithHerd}
enum AnimalActions {Idle,Sit,Hit,Wander,Chase,Dead,Search,Charge,Sleep,Graze,Dash}
@export var starting_goal :AnimalGoals = AnimalGoals.Nothing
var goals :Node
var corpse :Area2D
var current_speed :int
var current_action :AnimalActions
var current_goal :AnimalGoals
var old_goal_name :String
var old_action_name :String
var hurt_box :Area2D
@onready var anim :AnimalAnimations = $Animations

func __ready()->void:
	init_scenes_nodes()
	__signaler()
	animal_ready()
	change_goals(str(AnimalGoals.keys()[starting_goal]))

func __process(_delta:float)->void:
	pass

func init_scenes_nodes()->void:
	goals = $AnimalGoals
	hurt_box = $HurtBox
	current_action = AnimalActions.Idle
	add_to_group('animal')

func change_actions(new_action_name :String)->void:
	if new_action_name != AnimalActions.keys()[current_action]:
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
			"Graze":  current_action = AnimalActions.Graze
			"Dash":   current_action = AnimalActions.Dash
			_:        return
		anim.on_action_transition(new_action_name)
		old_action_name = new_action_name

func change_goals(new_goal_name :String)->void:
	if new_goal_name != AnimalGoals.keys()[current_goal]:
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

func __was_just_struck(_damage :int, _weapon :String, _who :AnzhuBeing)->void:
	change_actions("Hit")
	is_sliding = true

func uninjur()->void:
	is_injured = false
	is_stunned = false

func how_should_character_die()->void:
	change_actions("Dead")
	animal_death()

###VIRTUALS###
func animal_ready()->void:pass
func animal_process(_delta:float)->void: pass

func animal_strike()->void:pass
func animal_death()->void: pass
###VIRTUALS###
