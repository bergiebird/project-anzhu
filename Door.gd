@icon("res://warehouse/icons/color/icon_teleporter.png")
class_name Door extends Area2D

@export var pair :Door
var player :Player
var is_exit :bool = false:
	set(value): if is_exit != value:
		is_exit = value
		if is_exit:
			player.position = position

func _ready() -> void:
	_debug()
	Libraryton.player_reference.connect(func(ref): player = ref)
	body_entered.connect(teleport_player)
	body_exited.connect(player_exited)

func teleport_player(body: Player)->void:
	if not is_exit:
		pair.is_exit = true

func player_exited(body: Player)->void:
	if is_exit:
		is_exit = false

###
## DEBUG
###
@export_group('debug')
@export var debug :bool = false
@export var debug_color :Color = Swatchton.BROWN_DARKEST
func _debug()->void:
	assert(pair, self.name + " does not have a pair")
	if debug:
		$Sprite2D.visible = true
		Debuggerton.enable_print(self.name, debug_color)
	else:
		$Sprite2D.visible = false
