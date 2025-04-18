@icon('res://warehouse/_icons/node/icon_time.png')
extends Node #BearTimerManager.gd

var timer_dictionary :Dictionary = {}
var time_string :String = "Timer_"


func _ready()->void:
	for child in get_children():
		if child is Timer:
			timer_dictionary[child.name] = child

func start_timer(name_of_timer :String)->void:  timer_dictionary.get(time_string + name_of_timer).start()
func stop_timer(name_of_timer :String)->void:   timer_dictionary.get(time_string + name_of_timer).stop()
func change_timers_time(name_of_timer :String, new_time :int)->void: timer_dictionary.get(time_string + name_of_timer).wait_time = new_time
