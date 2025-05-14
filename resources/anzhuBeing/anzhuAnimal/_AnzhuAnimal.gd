class_name AnzhuAnimal extends AnzhuBeing #_AnzhuAnimal.gd

enum AnimalActions {Idle,Sit,Hit,Wander,Chase,Dead,Search,Charge,Sleep,Graze,Dash}
var old_action_name :String
var goals :Node
var corpse :Area2D
var current_speed :int
var current_action :AnimalActions
var hurt_box :Area2D

@onready var anim :AnimalAnimations = $Animations

func __ready()->void:
	init_scenes_nodes()
	__signaler()
	animal_ready()

func init_scenes_nodes()->void:
	goals = $AnimalGoals
	hurt_box = $HurtBox
	current_action = AnimalActions.Idle
	add_to_group('animal')



func __was_just_struck(_damage :int, _weapon :String, _who :AnzhuBeing)->void:
	publisher_one.emit("change_actions", "Hit")
	is_sliding = true

func uninjur()->void:
	is_injured = false
	is_stunned = false

func how_should_character_die()->void:
	publisher_one.emit("change_actions", "Dead")
	animal_death()

#region ##VIRTUALS###
func animal_ready()->void:pass
func animal_process(_delta:float)->void: pass

func animal_strike()->void:pass
func animal_death()->void: pass
#endregion ##VIRTUALS###
