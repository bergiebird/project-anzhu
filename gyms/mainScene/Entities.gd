class_name Entities extends CanvasGroup

func _ready() -> void:
	Libraryton.reference_emitter_deferred("entities_reference", self, debug)

#region #=========================================# DEBUG
@export var debug:bool = false
