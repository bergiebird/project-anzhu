@icon("res://resources/anzhuBeing/player/mainCamera/snowfall/snowflake.png")

class_name SnowFall
extends GPUParticles2D

@onready var sfx_wind: AudioStreamPlayer2D = $WindSFX
@onready var parent: Camera2D = get_parent()

func _ready():
	_debug()
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
@export var weather_pattern: WeatherPattern
@onready var size_weather_pattern: int = WeatherPattern.size()

func set_pattern():
		match weather_pattern:
			WeatherPattern.FULL_RANDOM:
				Sgnl.new_hour.connect(full_random_weather)
				full_random_weather()
			WeatherPattern.WEATHER_RANDOM:
				Sgnl.new_hour.connect(weather_random)
				weather_random()
			WeatherPattern.ONE_WEATHER:
				if weather_type == WeatherType.NOTHING:
					frequency = frequency
					direction = direction
					speed = speed
				else:
					weather_type = weather_type
				Sgnl.new_weather.emit(frequency, speed)

func weather_random():
	weather_type = Libraryton.rng.randi_range(0, WeatherType.size() - 1)
	Sgnl.new_weather.emit(frequency, speed)

func full_random_weather(_current_time = 0):
	direction = Libraryton.rng.randi_range(0,7)
	frequency = Libraryton.rng.randi_range(0,4)
	Sgnl.new_weather.emit(frequency, speed)
	_debug_weather_changed()

#endregion
#region    #=============================================# WEATHER TYPE
enum WeatherType{
	NOTHING, ## light breeze, no frequency, any wind direction
	WINDY, ## strong breeze, minimal frequency, within 3 directions
	DUSTING, ## light breeze, minimal frequency, any direction
	SNOWING, ## moderate breeze, high frequency, within 3 directions
	STORM, ## light gale, moderate frequency, within 2 directions
	BLIZZARD, ##strong gale, mostest frequency, within 1 direction
}
@export_group('Weather Control')
@export var weather_type: WeatherType:
	set(v): if is_inside_tree():
		weather_type = v
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

func wrap_values(mod: int, affected: int)->int:
	affected += mod
	if affected >= 8:
		affected -= 8
	elif affected < 0:
		affected += 8
	assert(affected >= 0 and affected < 8, "wrap_values() -> " + str(affected))
	return affected

#endregion
#region    #=============================================# WEATHER FREQUENCY
enum FrequencyType {
	MOSTEST = 1,
	ALOT = 2,
	NORMAL = 3,
	MINIMAL = 4,
	NONE = 0
}

@export var frequency: FrequencyType:
	set(v):
			update_frequency(v, frequency)
			frequency = v

var frequencies: Dictionary[int,float] = {
	FrequencyType.MOSTEST:200.0, FrequencyType.ALOT:300.0, FrequencyType.NORMAL:700.0,
	FrequencyType.MINIMAL:1900.0, FrequencyType.NONE:12000.0}

func update_frequency(val: int, old_val:int):
	var ftween_time: int = abs(val-old_val)
	if frequency == 5:
		emitting = false
	else:
		emitting = true
	Dbgr.tweener_property_disposal([
		Buildton.tweener(process_material, "emission_sphere_radius", frequencies[val], ftween_time)],debug)
	call_deferred("position_wind_sfx", ftween_time)

#endregion
#region    #=============================================# WEATHER DIRECTION
enum WindDirection {
	NORTH,
	NORTH_EAST,
	EAST,
	SOUTH_EAST,
	SOUTH,
	SOUTH_WEST,
	WEST,
	NORTH_WEST
}

@export var direction :WindDirection:
	set(v):
			Dbgr.tweener_property_disposal([
				Buildton.tweener(process_material, "direction", directions[v], abs(v-direction))],debug)
			wind_direction = Vector2(directions[v].x, directions[v].y)
			call_deferred("position_wind_sfx", abs(v-direction))
			direction = v
var directions: Dictionary[int,Vector3] = {
	WindDirection.NORTH: Vector3.DOWN,
	WindDirection.NORTH_EAST: Vector3.DOWN + Vector3.RIGHT,
	WindDirection.EAST: Vector3.RIGHT,
	WindDirection.SOUTH_EAST: Vector3.UP + Vector3.RIGHT,
	WindDirection.SOUTH: Vector3.UP,
	WindDirection.SOUTH_WEST: Vector3.UP + Vector3.LEFT,
	WindDirection.WEST: Vector3.LEFT,
	WindDirection.NORTH_WEST: Vector3.DOWN + Vector3.LEFT}
var wind_direction: Vector2


func position_wind_sfx(tween_time: int):
	if player:
		var position_new: Vector2 = parent.position - wind_direction * ((speed*speed*speed+10))*10
		var pitch_new: float = 1.4 - (float(frequency)* 0.1)
		Dbgr.tweener_property_disposal([
			Buildton.tweener(sfx_wind, "pitch_scale", pitch_new, tween_time),
			Buildton.tweener(sfx_wind, "position", position_new, tween_time)], debug)

#endregion
#region    #=============================================# WEATHER SPEED

enum WindSpeed {
	STRONG_GALE = 0,
	MODERATE_GALE = 1,
	LIGHT_GALE = 2,
	STRONG_BREEZE = 3,
	MODERATE_BREEZE = 4,
	LIGHT_BREEZE = 5,
	CALM = 6,
}

@export var speed: WindSpeed:
	set(v):
			var speed_int: int = wind_dict[speed]
			var value_int: int = wind_dict[v]
			Dbgr.tweener_property_disposal([
				Buildton.tweener(process_material, "linear_accel_min", value_int, abs(value_int - speed_int)),
				Buildton.tweener(process_material, "linear_accel_max", value_int, abs(value_int - speed_int))], debug)
			call_deferred("position_wind_sfx", abs(value_int - speed_int))
			speed = v

var wind_dict: Dictionary[WindSpeed,int] = {
	WindSpeed.STRONG_GALE: 128,
	WindSpeed.MODERATE_GALE: 64,
	WindSpeed.LIGHT_GALE: 48,
	WindSpeed.STRONG_BREEZE: 32,
	WindSpeed.MODERATE_BREEZE: 16,
	WindSpeed.LIGHT_BREEZE: 8,
	WindSpeed.CALM: 4,
	}

#endregion
#region    #=============================================# DEBUG

@export_group('debug')
@export var debug: bool = false
@export var debug_color: Color =Lib.Palette.WHITE_WHITE

var player: Player

func _debug():
	player = get_tree().get_first_node_in_group('player')
	Sgnl.reference_emitter_deferred("snowfall_reference", self, debug)
	if debug:
		Dbgr.enable_print(self.name, debug_color)
		_debug_weather_changed()

func _debug_weather_changed():
	if debug:
		Dbgr.dprint('weather update: ' +str(speed)+str(direction)+str(frequency), debug_color)



#endregion #=============================================# DEBUG
