@icon("res://resources/AnzhuBeing/audio/icon_audio.png")
class_name AudioManager extends Node2D #AudioManager.gd

var audio_dictionary :Dictionary[String, AudioStreamPlayer2D] = {}
var audio_string :String = "Sfx_"
@onready var parent :AnzhuBeing = get_parent()

func _ready()->void:
	for child :AudioStreamPlayer2D in get_children():
		audio_dictionary[child.name] = child
	__ready()
	__signaler()

func _signaler()->void:
	parent.publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	__signaler()

func start_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).playing = true
func stop_sfx(name_of_sfx :String)->void:
	audio_dictionary.get(audio_string + name_of_sfx).playing = false
func get_is_playing(name_of_sfx :String)->bool:
	return audio_dictionary.get(audio_string + name_of_sfx).playing

#region # VIRTUALS

func __ready()->void:pass
func __signaler()->void:pass
func __was_just_struck()->void: 	pass
func __match_observer(_method_name:String)->void:pass
#endregion

#region # DEBUG
@export_group('DEBUG')
@export var debug :bool = false

func _debug()->void:
	print_rich('[color=ebb85b]Audio debugging enabled . . .[/color]')
	debug = true
#endregion
