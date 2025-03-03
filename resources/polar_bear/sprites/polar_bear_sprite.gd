extends AnimatedSprite2D #polar_bear_sprite.gd

var action_states :Dictionary = {}
var current_action :ActionState
var is_stunned :bool = false
@export var debug_all :bool = false

func _ready()->void:
	for child in get_children():
		if child is ActionState:
			action_states[child.name] = child
			child.action_transition.connect(on_action_transition)
			if debug_all:
				child.self_debug = true

func _process(delta :float)->void:
	if current_action:
		current_action.update(delta)

func _physics_process(delta:float)->void:
	if is_stunned:
		return
	if current_action:
		current_action.physics_update(delta)

func on_action_transition(new_action_name :String, old_action = null)->void:
	if current_action != null:
		if new_action_name == current_action.name:
			return
	var verify_new_action :ActionState = action_states.get(new_action_name)
	if !verify_new_action: return
	if current_action: current_action.exit()
	current_action = verify_new_action
	current_action.enter()
	play(new_action_name)


func _on_hit_start()->void:
	is_stunned = true

func unstun()->void:
	is_stunned = false
