extends CanvasGroup #Tracks.gd

func _ready() -> void:
	Libraryton.reference_emitter_deferred("tracks_reference", self)

## To Be Used: With Storms
func cover_tracks(_map_ :TileMapLayer)->void:
	var covering_tween :Tween = create_tween()
	covering_tween.tween_property(_map_, "modulate", Swatchton.BASIC_WHITE_TRANSPARENT, 10.0)
	covering_tween.finished.connect(func(_map): _map_.clear())
