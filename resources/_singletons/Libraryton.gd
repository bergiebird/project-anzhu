extends Node #Libraryton.gd

func _ready()->void:
	_remove_digits_from_string()
	gloabl_get_and_emit_dictionaries()
#===========================================================
## Track Delivery Service: Designed to give all SnowTracker Nodes found in Character Scenes
signal deliver_tracks_dictionary(outgoing_tracks :Dictionary[String,Node])
var tracks_dictionary :Dictionary[String,Node]

func set_tracks(incoming_dictionary :Dictionary[String,Node])->void:
	call_deferred("set_tracks_dictionary", incoming_dictionary)
func set_tracks_dictionary(incoming_dictionary:Dictionary[String,Node])->void:
	tracks_dictionary = incoming_dictionary
	deliver_tracks_dictionary.emit(tracks_dictionary)

#===========================================================
## Global Node Delivery Service: Designed to provide anyone with all nodes in the given scene.

signal global_node_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
signal global_node2d_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
signal global_control_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
signal global_delivery(sum_of_all_dictionaries :Dictionary)
@onready var GAME = get_tree().current_scene

func gloabl_get_and_emit_dictionaries()->void:
	var all_dictionaries :Dictionary
	for root_child :String in ["NODE","CONTROL","NODE2D"]:
		all_dictionaries[root_child] = get_and_emit_particular_dictionaries(root_child, Signal(self, "global_" + root_child.to_lower() + "_delivery"))
	global_delivery.emit(all_dictionaries)

func get_and_emit_particular_dictionaries(what_container:String, delivery_network:Signal):
	var container :Node = GAME.find_child(what_container, true, false)
	var temporary_dictionary :Dictionary[String,Node]
	for child :Node in container.get_children():
		temporary_dictionary[child.name] = child
		for g_child in child.get_children():
			temporary_dictionary[child.name] = child
	delivery_network.emit(container)
	return temporary_dictionary


#===========================================================
## Track & Print: A function designed to only print when the particular property has been updated.

var _tracked_values :Dictionary = {}

func track_and_print(object, property_name, label = ""):
	if not object:
		return false
	var key = str(object.get_instance_id()) + "_" + property_name
	var current_value = object.get(property_name)
	if not _tracked_values.has(key):
		_tracked_values[key] = current_value
		print("%s%s = %s (initial)" % [label, property_name, current_value])
		return true
	if _tracked_values[key] != current_value:
		print("%s%s: %s -> %s" % [label, property_name, _tracked_values[key], current_value])
		_tracked_values[key] = current_value
		return true
	return false

#============================================================
@onready var pattern_that_removes_digits = RegEx.new() #Create a new pattern
@onready var pattern_that_lowercases_all = RegEx.new()

func _remove_digits_from_string()->void:
	pattern_that_removes_digits.compile('\\d') #initialize that pattern to find digits

func remove_digits_from_string(input_string :String)->String:
	return pattern_that_removes_digits.sub(input_string,'',true)
#============================================================
