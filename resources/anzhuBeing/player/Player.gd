@icon("res://resources/anzhuBeing/player/player.png") #Player.gd
class_name Player extends AnzhuHuman

signal affect_nighlight(is_leaving_campfire :bool)

@onready var camera :Camera2D = $MainCamera
@onready var abilities: Node = $Abilities
@onready var listener :AudioListener2D = $AudioListener2D
@onready var nightlight :PointLight2D = $Nightlight

func human_ready()->void:
	Libraryton.reference_emitter_deferred("player_reference", self)
	add_to_group('player')

func __physics_process(delta :float)->void:
	velocity = Vector2.ZERO
	abilities.process_able()
	anim.movement_animation(velocity)

func how_should_character_die()->void:
	Signalton.reload_scene.emit()

func character_signaler()->void:
	abilities.jumping.connect(process_jump)

func process_jump(needs_inverse :bool)->void:
	var can_go_over_walls :bool = !needs_inverse
	set_collision_layer_value(1, can_go_over_walls)
	set_collision_mask_value(1, can_go_over_walls)









###
##Debug
###
func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/player/player.png[/img]"
		print_rich(debug_icon)

func debug()->void:
	pass
