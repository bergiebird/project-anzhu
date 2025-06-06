@icon("res://resources/anzhuBeing/player/mainCamera/snowfall/snowflake.png")
extends GPUParticles2D
class_name SnowFall

@onready var sfx_wind :AudioStreamPlayer2D = $WindSFX
@onready var parent :Camera2D = get_parent()
func _ready():
	_debug()
	print("PATTERN: " + str(weather_pattern))
	set_pattern()
	weather_pattern = weather_pattern
	if not Engine.is_editor_hint():
		sfx_wind.call_deferred("play")
	emitting = true

#region    #==============================================# WEATHER PATTERN
enum WeatherPattern {
	FULL_RANDOM=0,  ## Randomly choose all values every time_change
	WEATHER_RANDOM=1, ## Randomly choose Weather Type every time change
	ONE_WEATHER=2, ## Ensures the weather never changes from how it is set
	}
## Set the overall pattern of the snowfall
@export var weather_pattern :WeatherPattern

func set_pattern():
		match weather_pattern:
			WeatherPattern.FULL_RANDOM:
				Signalton.new_hour.connect(full_random)
				full_random()
			WeatherPattern.WEATHER_RANDOM:
				Signalton.new_hour.connect(weather_random)
				weather_random()
			WeatherPattern.ONE_WEATHER:
				if weather_type == WeatherType.NOTHING:
					frequency = frequency
					direction = direction
					speed = speed
				else:
					weather_type = weather_type
@onready var size_weather_pattern :int = WeatherPattern.size()

func weather_random():
	weather_type = Libraryton.rng.randi_range(0, WeatherType.size() - 1)

func full_random(_current_time = 0):
	direction = Libraryton.rng.randi_range(0,7)
	frequency = Libraryton.rng.randi_range(0,4)
	_debug_weather_changed()

#endregion #=============================================# WEATHER PATTERN
@export_group('Weather Control')
#region    #=============================================# WEATHER TYPE
enum WeatherType{
	NOTHING, ## light breeze, no frequency, any wind direction
	WINDY, ## strong breeze, minimal frequency, within 3 directions
	DUSTING, ## light breeze, minimal frequency, any direction
	SNOWING, ## moderate breeze, high frequency, within 3 directions
	STORM, ## light gale, moderate frequency, within 2 directions
	BLIZZARD, ##strong gale, mostest frequency, within 1 direction
}
@export var weather_type :WeatherType:
	set(value):if is_inside_tree():
		weather_type = value
		match weather_type:
			WeatherType.NOTHING:
				print_rich("[color=lightblue][b]CALM[/b][/color] - Just a gentle whisper of wind... [i]barely enough to rustle a leaf![/i] 🌤️")
				frequency = FrequencyType.NONE
				speed = WindSpeed.CALM
				direction = wrap_values(Libraryton.rng.randi_range(-7,7), direction)
			WeatherType.WINDY:
				print_rich("[color=lightblue][b]CALM[/b][/color] - Just a gentle whisper of wind... [i]barely enough to rustle a leaf![/i] 🌤️")
				frequency = FrequencyType.MINIMAL
				speed = WindSpeed.LIGHT_GALE
				direction = wrap_values(Libraryton.rng.randi_range(-3,3), direction)
			WeatherType.DUSTING:
				print_rich("[color=white][b]DUSTING[/b][/color] - Just a sprinkle of snow... [i]like nature's confetti![/i] ❄️")
				frequency = FrequencyType.NORMAL
				speed = WindSpeed.LIGHT_BREEZE
				direction = wrap_values(Libraryton.rng.randi_range(-7,7), direction)
			WeatherType.SNOWING:
				print_rich("[color=cyan][b]SNOWING[/b][/color] - Now we're talking! [wave]Proper snowfall incoming[/wave] - time for cocoa! 🌨️")
				frequency = FrequencyType.ALOT
				speed = WindSpeed.CALM
				direction = wrap_values(Libraryton.rng.randi_range(-3,3), direction)
			WeatherType.STORM:
				print_rich("[color=orange][b]STORM[/b][/color] - [shake rate=20.0 level=10]Mother Nature is ANGRY![/shake] Batten down the hatches! ⛈️")
				frequency = FrequencyType.ALOT
				speed = WindSpeed.MODERATE_GALE
				direction = wrap_values(Libraryton.rng.randi_range(-2,2), direction)
			WeatherType.BLIZZARD:
				print_rich("[color=red][b][shake rate=30.0 level=15]BLIZZARD - ABSOLUTE CHAOS![/shake][/b][/color] [tornado]Even the snowflakes don't know where they're going![/tornado] 🌪️")
				frequency = FrequencyType.MOSTEST
				speed = WindSpeed.STRONG_GALE
				direction = wrap_values(Libraryton.rng.randi_range(-1,1), direction)

func wrap_values(mod :int, affected :int)->int:
	affected += mod
	if affected >= 8:
		affected -= 8
	elif affected < 0:
		affected += 8
	assert(affected >= 0 and affected < 8, "wrap_values() -> " + str(affected))
	return affected

#endregion #=============================================# WEATHER TYPE
#region    #=============================================# WEATHER FREQUENCY
enum FrequencyType {
	MOSTEST, ALOT, NORMAL, MINIMAL, NONE}
@export var frequency :FrequencyType:
	set(value):
			update_frequency(value, frequency)
			frequency = value
var frequencies :Dictionary[int,float] = {
	FrequencyType.MOSTEST:200.0, FrequencyType.ALOT  :300.0, FrequencyType.NORMAL  :700.0,
	FrequencyType.MINIMAL :1900.0, FrequencyType.NONE    :12000.0,}

func update_frequency(val :int, old_val:int):
	var ftween_time :int = abs(val-old_val)
	if frequency == 5: emitting = false
	else:              emitting = true
	Debuggerton.tweener_property_disposal([
		Builderton.tweener(process_material, "emission_sphere_radius", frequencies[val], ftween_time)],debug)
	call_deferred("position_wind_sfx", ftween_time)
#endregion #=============================================# WEATHER FREQUENCY
#region    #=============================================# WEATHER DIRECTION
enum WindDirection {
	NORTH,
	NORTH_EAST,
	EAST,
	SOUTH_EAST,
	SOUTH,
	SOUTH_WEST,
	WEST,
	NORTH_WEST}
var directions :Dictionary[int,Vector3] = {
	WindDirection.NORTH: Vector3.DOWN,
	WindDirection.NORTH_EAST: Vector3.DOWN + Vector3.RIGHT,
	WindDirection.EAST: Vector3.RIGHT,
	WindDirection.SOUTH_EAST: Vector3.UP + Vector3.RIGHT,
	WindDirection.SOUTH: Vector3.UP,
	WindDirection.SOUTH_WEST: Vector3.UP + Vector3.LEFT,
	WindDirection.WEST: Vector3.LEFT,
	WindDirection.NORTH_WEST: Vector3.DOWN + Vector3.LEFT}
@export var direction :WindDirection:
	set(value):
			Debuggerton.tweener_property_disposal([
				Builderton.tweener(process_material, "direction", directions[value], abs(value-direction))],debug)
			wind_direction = Vector2(directions[value].x, directions[value].y)
			call_deferred("position_wind_sfx", abs(value-direction))
			direction = value
var wind_direction :Vector2


func position_wind_sfx(tween_time :int):
	if player:
		var position_new :Vector2 = parent.position - wind_direction * ((speed*speed*speed+10))*10
		var pitch_new :float = 1.4 - (float(frequency)*0.1)
		Debuggerton.tweener_property_disposal([
			Builderton.tweener(sfx_wind, "pitch_scale", pitch_new, tween_time),
			Builderton.tweener(sfx_wind, "position", position_new, tween_time)], debug)
#endregion    #=============================================# WEATHER DIRECTION
#region    #=============================================# WEATHER SPEED
enum WindSpeed {
	STRONG_GALE,
	MODERATE_GALE,
	LIGHT_GALE,
	STRONG_BREEZE,
	MODERATE_BREEZE,
	LIGHT_BREEZE,
	CALM,
	}
var wind_dict :Dictionary[WindSpeed,int] = {
	WindSpeed.STRONG_GALE : 128,
	WindSpeed.MODERATE_GALE : 64,
	WindSpeed.LIGHT_GALE : 48,
	WindSpeed.STRONG_BREEZE : 32,
	WindSpeed.MODERATE_BREEZE : 16,
	WindSpeed.LIGHT_BREEZE : 8,
	WindSpeed.CALM : 4,
	}
@export var speed :WindSpeed:
	set(value):
			var speed_int :int = wind_dict[speed]
			var value_int :int = wind_dict[value]
			Debuggerton.tweener_property_disposal([
				Builderton.tweener(process_material, "linear_accel_min", value_int, abs(value_int - speed_int)),
				Builderton.tweener(process_material, "linear_accel_max", value_int, abs(value_int - speed_int))], debug)
			call_deferred("position_wind_sfx", abs(value_int - speed_int))
			speed = value

#endregion #=============================================# WEATHER SPEED
#region    #=============================================# DEBUG

@export_group('debug')
@export var debug :bool = false
@export var debug_color :Color =L.Palette.WHITE_WHITE

func _debug():
	Signalton.player_reference.connect(player_reference_collector)
	Signalton.reference_emitter_deferred("snowfall_reference", self, debug)
	if debug:
		Debuggerton.enable_print(self.name, debug_color)

func _debug_weather_changed():
	if debug:
		Debuggerton.dprint('weather update: ' +str(speed)+str(direction)+str(frequency), debug_color)

var player :Player
func player_reference_collector(ref :Player):
	player = ref
	Signalton.player_reference.disconnect(player_reference_collector)

#endregion #=============================================# DEBUG
