class_name Eyesight extends VisibleOnScreenNotifier2D

@onready var parent :AnzhuBeing = get_parent()

signal spotted_player(bool)

func _ready() -> void:
	__ready()
	_signaler()
	__signaler()

func __ready()->void:    pass
func _signaler()->void:  pass
func __signaler()->void: pass


#region # DEBUG
@export_category('DEBUG')
@export var debug_eyesight :bool = false
func debug()->void:
	debug_eyesight = true
	assert(spotted_player)
#endregion
