@icon("res://resources/environment/objectsSmart/door/door.png")
class_name Door extends Area2D

@export_group("Basics")
@export var pair :Door

@export_group("Uniques")
@export var is_permanently_closed :bool

var player :Player
var is_exit :bool = false:
	set(value): if is_exit != value:
		is_exit = value
		if is_exit:
			player.position = position

func _ready():
	_debug()
	Sgnl.player_reference.connect(_player_reference_collection)
	body_entered.connect(_teleport_player)
	body_exited.connect(_player_exited)

func _teleport_player(body: Node2D):
	if is_permanently_closed:
		return
	if not is_exit and body is Player:
		pair.is_exit = true
		body.current_direction = body.PersonalDirection.SOUTH

func _player_exited(body: Node2D):
	if is_exit and body is Player:
		is_exit = false

func _player_reference_collection(ref :Player):
	player = ref
	Sgnl.player_reference.disconnect(_player_reference_collection)

#region	 DEBUG

@export_group('debug')
@export var debug: bool = false
@export var debug_color: Color =Lib.Palette.BROWN_DARKEST
@onready var debug_sprite: Sprite2D = $DebugSprite

func _debug():
	assert(pair, self.name + " does not have a pair")
	if debug:
		debug_sprite.visible = true
		Dbgr.enable_print(self.name, debug_color)
	else:
		debug_sprite.visible = false
#endregion
