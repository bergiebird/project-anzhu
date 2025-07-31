
class_name MainCamera
extends Camera2D

enum DebugView{
	NO_CRT = 100,
	NONE = 12,
	FAR = 8,
	FARTHEST = 3,
 }

@export var debug_view: DebugView = DebugView.NONE:
	set(v):
		debug_view = v
		if not is_node_ready():
			await self.ready
		visible = true
		match debug_view:
			DebugView.NO_CRT:
				zoom = Vector2(11,11)
				$CRT.visible = false
			_:
				zoom = Vector2(debug_view, debug_view*.75)
				$CRT.visible = (zoom == Vector2(12.0,9.0))
