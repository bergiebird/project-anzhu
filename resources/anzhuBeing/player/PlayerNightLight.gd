extends PointLight2D
class_name PlayerNightLight

@export var minimum_light: float = 0.06
@export var maximum_light: float = 0.17
@export var fast_time: float = 0.1
@export var slow_time: float = 35.0

@onready var abilities: Abilities = get_parent().get_node('Abilities')
@onready var parent: Player = get_parent()


func _ready()->void:
	Sgnl.new_hour_nightlight.connect(update_nightlight)
	parent.publish_event.connect(func(func_name, data:Variant=null):Lib.Observe.subscribe_to_event(self, func_name, data))
#	timer_node.timeout.connect(func():return)
	energy = minimum_light
	_debug()


func update_nightlight(should_nightlight_be_on: bool)->void:
	if should_nightlight_be_on:
		if not visible:
			change_nightlight(maximum_light, slow_time)
	else:
		if visible:
			change_nightlight(minimum_light, slow_time)


## Not in use
## This makes everything super dark temporarily
#func gunfired(did_gun_fire: bool)->void:
	#if did_gun_fire:
		#change_nightlight(minimum_light, fast_time)

func change_nightlight(m_energy: float, wait_time: float)->void:
	Dbgr.tweener_property_disposal([
		Buildton.tweener_deferred(self, 'energy', m_energy, wait_time, Tween.TRANS_EXPO)], debug)
	#if visible:
		#if m_energy == minimum_light:
			#timer_node.wait_time = wait_time
			#timer_node.start()

#region # DEBUG
@export_group("DEBUG")
@export var debug: bool = false
func _debug()->void:
	if debug:
		print_rich('[color=2a2942]NightLight debugging enabled . . .[/color]')
#endregion
