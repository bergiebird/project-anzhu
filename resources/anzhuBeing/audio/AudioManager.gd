@icon("res://resources/AnzhuBeing/audio/icon_audio.png")
class_name AudioManager extends Node2D #AudioManager.gd

var audio_dictionary :Dictionary[String, Node] = {}
var audio_string :String = "Sfx_"
@onready var parent :AnzhuBeing = get_parent()

func _ready()->void:
	for child in get_children():
		if child is AudioStreamPlayer2D:
			audio_dictionary[child.name] = child
	__ready()
	__signaler()

func _signaler()->void:
	parent.was_struck.connect(__was_just_struck)
	parent.striking.connect(__character_is_striking)
	__signaler()

func start_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).play()
func stop_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).stop()
func get_is_playing(name_of_sfx :String)->bool:
	return audio_dictionary.get(audio_string + name_of_sfx).is_playing()


###
## VIRTUALS
###
func __ready()->void:pass
func __signaler()->void:pass
func __was_just_struck()->void: 	pass
func __character_is_striking()->void:pass

###
## DEBUG
###
@export_group('DEBUG')
@export var debug_audio :bool = false

func debug()->void:
	print_rich('[color=ebb85b]Audio debugging enabled . . .[/color]')
	debug_audio = true
