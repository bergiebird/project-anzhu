extends CanvasGroup
class_name TracksManager

@export var mod_tracks_amount: float = 15.0

@onready var new_tracks: Array[TileMapLayer] = []
@onready var tracks_being_weathered: Array[TileMapLayer] = []
@onready var tweens: Array[Tween] = []
@onready var timer: Timer = $StormTimer


func _ready() -> void:
	Sgnl.reference_emitter_deferred("tracks_reference", self)
	Sgnl.new_weather.connect(_on_new_weather)


func mod_tracks() -> void:
	print("~~~~~~~~~~PULSE~~~~~~~~~~")
	if new_tracks.size() == 0:
		for child: Node in get_children():
			if child is TileMapLayer:
				new_tracks.append(child)

	for track: TileMapLayer in new_tracks:
		var new_weathered_track: TileMapLayer = track.duplicate()
		add_child(new_weathered_track)
		tracks_being_weathered.append(new_weathered_track)
		track.clear()

	if tracks_being_weathered.size() != 0:
		var to_be_removed: Array[TileMapLayer]
		for track: TileMapLayer in tracks_being_weathered:
			if track.modulate.a <= 0.0:
				to_be_removed.append(track)
				track.queue_free()
			else:
				var tween: Tween = create_tween()
				tweens.append(tween)
				tween.tween_property(track, ^"modulate:a", 0.0, timer.wait_time)

		if to_be_removed:
			for track: TileMapLayer in to_be_removed:
				tracks_being_weathered.erase(track)


func _on_new_weather(how_much_snow: float, how_fast_snow_moves: float) -> void:
	var new_wait_time: float = how_much_snow * (how_fast_snow_moves + 1.0) * mod_tracks_amount
	printt("NEW WEATHER PATTERN STATS: ", how_much_snow, how_fast_snow_moves, new_wait_time)
	if tweens:
		for tween: Tween in tweens:
			tween.kill()
		tweens.clear()
	if new_wait_time <= 0.0:
		timer.stop()
	else:
		timer.start(new_wait_time)
		mod_tracks()
