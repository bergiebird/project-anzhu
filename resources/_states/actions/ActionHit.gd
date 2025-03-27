extends ActionState #ActionHit.gd

var default_color :Color = Color("ffffff")
var red_color :Color = Color("b74132")
var is_colored :bool = false
var hurt_box_node :Area2D
var stats_node :CollisionShape2D


func enter()->void:
	hurt_box_node.monitoring = false
	if grandparent.name == "Bear":
		goal_transition.emit('Hunt')
	was_just_hit()

func was_just_hit()->void:
	stats_node.take_damage()
	parent.modulate = red_color
	for index in 4:
		is_colored = !is_colored
		parent.self_modulate = red_color if is_colored else default_color
		await get_tree().create_timer(.4).timeout
	parent.modulate = default_color
	parent.self_modulate = default_color
	exit()

func exit()->void:
	hurt_box_node.monitoring = true
	grandparent.uninjur()


func update(delta :float)->void:return
func physics_update(delta :float)->void:return
