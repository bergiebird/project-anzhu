@icon("res://resources/anzhuBeing/player/mainCamera/snowfall/snowflake.png")
extends GPUParticles2D
class_name SnowFall

@export_group('Weather Control')
enum FrequencyType{BLIZZARD,SQUALL, NORMAL,DUSTING, NONE}
@export var frequency :FrequencyType:
	set(value):
		if value != frequency:
			update_frequency(value, frequency)
			frequency = value
var frequencies :Dictionary[int,float] = {
	FrequencyType.BLIZZARD:200.0, FrequencyType.SQUALL  :300.0, FrequencyType.NORMAL  :700.0,
	FrequencyType.DUSTING :1900.0, FrequencyType.NONE    :12000.0,}

enum WindDirection{NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST}
@export var direction :WindDirection:
	set(value):
		if value != direction:
			update_direction(value, direction)
			direction = value
var directions :Dictionary[int,Vector3] = {
	WindDirection.NORTH: Vector3.DOWN, WindDirection.NORTHEAST: Vector3.DOWN + Vector3.RIGHT,
	WindDirection.EAST: Vector3.RIGHT, WindDirection.SOUTHEAST: Vector3.UP + Vector3.RIGHT,
	WindDirection.SOUTH: Vector3.UP, WindDirection.SOUTHWEST: Vector3.UP + Vector3.LEFT,
	WindDirection.WEST: Vector3.LEFT, WindDirection.NORTHWEST: Vector3.DOWN + Vector3.LEFT,}

enum WindSpeed{BLIZZARD,SQUALL,GALE,STRONGBREEZE,MODERATEBREEZE,LIGHTBREEZE,CALM,}
@export var speed :WindSpeed:
	set(value):
		if value != speed:
			update_speed(value, speed)
			speed = value
var speeds :Dictionary[int, int] = {
	WindSpeed.BLIZZARD: 128, WindSpeed.SQUALL: 64, WindSpeed.GALE: 48, WindSpeed.STRONGBREEZE: 32,
	WindSpeed.MODERATEBREEZE: 16, WindSpeed.LIGHTBREEZE: 8, WindSpeed.CALM: 4,}

var wind_direction :Vector2
@onready var sfx_wind :AudioStreamPlayer2D = $WindSFX
@onready var parent :Camera2D = get_parent()

func _ready():
	_debug()
	DayNighton.time_progressed.connect(func(_current_time :DayNighton.TimeOfDay): change_weather_randomly())
	Libraryton.player_reference.connect(player_reference_collector)
	Libraryton.reference_emitter_deferred("snowfall_reference", self, debug)
	change_weather_randomly()
	update_frequency(frequency, frequency)
	update_direction(direction, direction)
	update_speed(speed, speed)
	if not Engine.is_editor_hint():
		sfx_wind.call_deferred("play")
	emitting = true

func update_frequency(val :int, old_val:int):
	var ftween_time :int = abs(val-old_val)
	if frequency == 5: emitting = false
	else:              emitting = true
	Debuggerton.tweener_property_disposal([
		Builderton.tweener(process_material, "emission_sphere_radius", frequencies[val], ftween_time)],debug)
	call_deferred("position_wind_sfx", ftween_time)

func update_direction(val :int, old_val:int):
	var dtween_time :int = abs(val-old_val)
	Debuggerton.tweener_property_disposal([
		Builderton.tweener(process_material, "direction", directions[val], dtween_time)],debug)
	wind_direction = Vector2(directions[val].x, directions[val].y)
	call_deferred("position_wind_sfx", dtween_time)

func update_speed(val :int, old_val :int):
	var stween_time :int = abs(val - old_val)
	Debuggerton.tweener_property_disposal([
		Builderton.tweener(process_material, "linear_accel_min", speeds[val],stween_time),
		Builderton.tweener(process_material, "linear_accel_max", speeds[val],stween_time)], debug)
	call_deferred("position_wind_sfx", stween_time)

func position_wind_sfx(tween_time :int):
	if player:
		var position_new :Vector2 = parent.position - wind_direction*((speed*speed*speed+10))*10
		var pitch_new :float = 1.4 - (float(frequency)*0.1)
		Debuggerton.tweener_property_disposal([
			Builderton.tweener(sfx_wind, "pitch_scale", pitch_new, tween_time),
			Builderton.tweener(sfx_wind, "position", position_new, tween_time)], debug)

func change_weather_randomly():
	direction = Libraryton.rng.randi_range(0,7)
	frequency = Libraryton.rng.randi_range(0,4)
	_debug_weather_changed()

var player :Player
func player_reference_collector(ref :Player):
	player = ref
	Libraryton.player_reference.disconnect(player_reference_collector)

#region #========================================================================================================# DEBUG

@export_group('debug')
@export var debug :bool = false
@export var debug_color :Color = Swatchton.WHITE_WHITE

func _debug() :
	if debug:
		Debuggerton.enable_print(self.name, debug_color)

func _debug_weather_changed():
	if debug:
		Debuggerton.dprint('weather update: ' +str(speed)+str(direction)+str(frequency), debug_color)

#endregion #=====================================================================================================# DEBUG
