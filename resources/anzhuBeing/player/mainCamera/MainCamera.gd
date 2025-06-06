extends Camera2D
class_name MainCamera

enum DebugView{ NoCRT=100, None=12, Far=8, Farthest=3 }

@export var debug_view :DebugView = DebugView.None:
	set(value):
		debug_view = value
		if not is_node_ready():
			await self.ready
		visible = true
		match debug_view:
			DebugView.NoCRT:
				zoom = Vector2(11,11)
				$CRT.visible = false
			_:
				zoom = Vector2(debug_view, debug_view*.75)
				$CRT.visible = (zoom == Vector2(12.0,9.0))
