@icon("res://warehouse/_icons/node_2D/icon_area_meteo.png")
extends CanvasModulate
@onready var day_night_system :DayNighton = DayNighton
@onready var timer_node :Timer = $WorldTimer
@onready var time_to_pass :int = int(timer_node.wait_time)
@export_enum("DAWN", "MORNING", "NOON", "AFTERNOON", "EVENING", "DUSK", "NIGHT", "MIDNIGHT", "LATE_NIGHT")
var time_right_before_start: int = day_night_system.TimeOfDay.LATE_NIGHT
@export_group('dawn')
@export var dawn_amount :int = 170
@export var dawn_lerp_time :float = 2
var init_dawn_lerp_time :int
@export_group('morning')
@export var morning_amount :int = 250
@export var morning_lerp_time :float = 0
var init_morning_lerp_time :int
@export_group('noon')
@export var noon_amount :int = 255
@export var noon_lerp_time :float = 0
var init_noon_lerp_time :int
@export_group('afternoon')
@export var afternoon_amount :int = 254
@export var afternoon_lerp_time :float = 0
var init_afternoon_lerp_time :int
@export_group('evening')
@export var evening_amount :int = 240
@export var evening_lerp_time :float = 30
var init_evening_lerp_time :int
@export_group('dusk')
@export var dusk_amount :int = 170
@export var dusk_lerp_time :float = 170
var init_dusk_lerp_time :int
@export_group('night')
@export var night_amount :int = 100
@export var night_lerp_time :float = 30
var init_night_lerp_time :int
@export_group('midnight')
@export var midnight_amount :int = 97
@export var midnight_lerp_time :float = 0
var init_midnight_lerp_time :int
@export_group('late_night')
@export var late_night_amount :int = 100
@export var late_night_lerp_time :float = 0
var init_late_night_lerp_time :int
@onready var time_lerp :Array = [dawn_lerp_time, morning_lerp_time, noon_lerp_time, afternoon_lerp_time, evening_lerp_time,
dusk_lerp_time, night_lerp_time, midnight_lerp_time, late_night_lerp_time]
@onready var init_time_lerp :Array = [init_dawn_lerp_time, init_morning_lerp_time, init_noon_lerp_time, init_afternoon_lerp_time,
init_evening_lerp_time, init_dusk_lerp_time, init_night_lerp_time, init_midnight_lerp_time, init_late_night_lerp_time]
var modulates_time_of_day_dictionary :Dictionary
var tween :Tween

func _ready()->void:
	_prepare_lerp_time()
	day_night_system.time_dictionary_delivery.connect(initialize_dictionary)
	day_night_system.initialize(self)
	day_night_system.time_progressed.connect(sun_change)
	day_night_system.progress_time(time_right_before_start)


func sun_change(new_time)->void:
	print('time has changed and now the lighting is different:', modulates_time_of_day_dictionary[new_time]['name'])
	var rgb_calculated :float = modulates_time_of_day_dictionary[new_time]['modulate']/255.0
	var target_color = Color(rgb_calculated,rgb_calculated,rgb_calculated)
	if tween and tween.is_valid(): tween.kill() #ends the tween if in progress
	tween = create_tween()
	tween.tween_property(self, 'color', target_color, modulates_time_of_day_dictionary[new_time]['modulate_duration'])

func _prepare_lerp_time()->void:
	for index in len(time_lerp):
		if time_lerp[index] <= 1:
			init_time_lerp[index] = 1
		else:
			init_time_lerp[index] = int(time_to_pass/time_lerp[index]) #replace with time_to_pass

func initialize_dictionary(incoming_delivery :Dictionary)->void:
	modulates_time_of_day_dictionary = incoming_delivery
