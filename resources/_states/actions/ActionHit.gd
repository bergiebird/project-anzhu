class_name ActionHit extends ActionState

const DEFAULT_COLOR :Color = Swatchton.BASIC_WHITE
const RED_COLOR :Color = Swatchton.RED_TOMATO
const BLINKS :int = 4
var is_colored :bool = false
var hurt_box_node :Area2D
var mask :CollisionShape2D
var snow_tracker :Node

func ___ready() -> void:
	hurt_box_node = grandparent.hurt_box

func enter()->void:
	grandparent.is_stunned = true
	grandparent.is_injured = true
	hurt_box_node.monitoring = false
	if grandparent.name == "Bear":
		grandparent.change_goals("Hunt")
	was_just_hit()

func was_just_hit()->void:
	parent.modulate = RED_COLOR
	for index :int in BLINKS:
		is_colored = !is_colored
		parent.self_modulate = RED_COLOR if is_colored else DEFAULT_COLOR
		await get_tree().create_timer(.4).timeout

func exit()->void:
	parent.self_modulate = DEFAULT_COLOR
	parent.modulate = DEFAULT_COLOR
	hurt_box_node.monitoring = true
	if grandparent.has_method("uninjur"):
		grandparent.uninjur()
