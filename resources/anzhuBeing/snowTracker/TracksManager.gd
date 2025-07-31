extends CanvasGroup
class_name TracksManager

@export var debug: bool = false

func _ready():
	Sgnl.reference_emitter_deferred("tracks_reference", self, debug)
