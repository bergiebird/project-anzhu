extends ActionState #ActionHit.gd

const DEFAULT_COLOR :Color = Color("ffffff")
const RED_COLOR :Color = Color("b74132")
var is_colored :bool = false
var hurt_box_node :Area2D
var mask :CollisionShape2D
var snow_tracker :Node

func _ready() -> void:
	parent.animation_finished.connect(inform_grandparent_that_hit_is_over)

func enter()->void:
	grandparent.is_stunned = true
	grandparent.is_injured = true
	hurt_box_node.monitoring = false
	if grandparent.name == "Bear":
		goal_transition.emit('Hunt')
	was_just_hit()

func was_just_hit()->void:
	parent.modulate = RED_COLOR
	for index in 4:
		is_colored = !is_colored
		parent.self_modulate = RED_COLOR if is_colored else DEFAULT_COLOR
		await get_tree().create_timer(.4).timeout

func exit()->void:
	parent.self_modulate = DEFAULT_COLOR
	parent.modulate = DEFAULT_COLOR
	snow_tracker.set_is_sliding(false)
	hurt_box_node.monitoring = true
	grandparent.uninjur()

func inform_grandparent_that_hit_is_over()->void:
	grandparent.character_hit_over()


# To prevent console's debug from going crazy, these are empty
func update(delta :float)->void:return
func physics_update(delta :float)->void:return
