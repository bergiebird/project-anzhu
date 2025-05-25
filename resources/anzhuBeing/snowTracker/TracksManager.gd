extends CanvasGroup
class_name TracksManager

@export var debug: bool = false

func _ready():
	Libraryton.reference_emitter_deferred("tracks_reference", self, debug)

func cover_tracks(_map_: TileMapLayer):
	var covering_tween: Tween = create_tween()
	Debuggerton.tweener_property_disposal([
		covering_tween.tween_property(_map_, "modulate", Swatchton.BASIC_WHITE_TRANSPARENT, 10.0)], debug)
	covering_tween.finished.connect(func() -> void: _map_.clear())
#ai AI li LI lI Li
#Label
