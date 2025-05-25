extends Camera2D
class_name MainCamera

signal crt_visibility(bool)

enum DebugView{
	NoCRT=100,
	None=12,
	Far=8,
	Farthest=3}

@export var debug_view :DebugView = DebugView.None:
	set(value):
		debug_view = value
		match debug_view:
			DebugView.NoCRT:
				zoom = Vector2(11,11)
				crt_visibility.emit(false)
			_:
				zoom = Vector2(debug_view, debug_view*.75)
				crt_visibility.emit(zoom == Vector2(12.0,9.0))

func _ready()->void:
	visible = true
