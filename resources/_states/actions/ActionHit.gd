extends ActionState #ActionHit.gd

const DEFAULT_COLOR :Color = Color("ffffff")
const RED_COLOR :Color = Color("b74132")
const BLINKS :int = 4
var is_colored :bool = false
var hurt_box_node :Area2D
var mask :CollisionShape2D
var snow_tracker :Node

func _ready() -> void:
	if parent == null:
		await get_tree().process_frame


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
	if grandparent.has_method("character_was_hit_over"):
		grandparent.character_was_hit_over()

func exit()->void:
	parent.self_modulate = DEFAULT_COLOR
	parent.modulate = DEFAULT_COLOR
	hurt_box_node.monitoring = true
	if grandparent.has_method("uninjur"):
		grandparent.uninjur()


func _collect_dictionary(incoming_dictionary :Dictionary[String,Node])->void:
	hurt_box_node = incoming_dictionary['HurtBox']
	mask = incoming_dictionary['Mask']
	snow_tracker = incoming_dictionary['SnowTracker2D']

# To prevent console's debug from going crazy, these are empty
func update(_delta :float)->void:return
func physics_update(_delta :float)->void:return
