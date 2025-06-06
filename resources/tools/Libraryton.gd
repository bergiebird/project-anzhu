extends Node
## Libraryton.gd
#region    #============================================================# Ready

func _ready()->void:
	debug_remove_digits_from_string = _remove_digits_from_string()
	_rng()
	gloabl_get_emit_dicts()
	_debug()

#endregion #============================================================# Ready
#region    #============================================================# Track Delivery

## Track Delivery Service: Designed to give all SnowTracker Nodes found in Character Scenes
signal deliver_tracks_dictionary(outgoing_tracks :Dictionary[String,Node])
var tracks_dictionary :Dictionary[String,Node]

func set_tracks(incoming_dictionary :Dictionary[String,Node])->void:
	call_deferred("set_tracks_dictionary", incoming_dictionary)
func set_tracks_dictionary(incoming_dictionary:Dictionary[String,Node])->void:
	tracks_dictionary = incoming_dictionary
	deliver_tracks_dictionary.emit(tracks_dictionary)

#endregion #============================================================# Track Delivery
#region    #============================================================# Global Delivery

## Global Node Delivery Service: Designed to provide anyone with all nodes in the given scene.

signal global_node_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
signal global_node2d_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
signal global_delivery(sum_of_all_dictionaries :Dictionary)
@onready var GAME :Node2D = get_tree().current_scene

func gloabl_get_emit_dicts()->void:
	var all_dictionaries :Dictionary
	for root_child :String in ["NODE","NODE2D"]:
		all_dictionaries[root_child] = get_emit_dicts(root_child, Signal(self, "global_" + root_child.to_lower() + "_delivery"))
	global_delivery.emit(all_dictionaries)

func get_emit_dicts(what_container:String, delivery_network:Signal)->Dictionary:
	var container :Node = GAME.find_child(what_container, true, false)
	delivery_network.emit(container)
	return getChildren_filterDictionary( {}, container)

#endregion #============================================================# GLOBAL DELIVERY
#region    #============================================================# Track & Print

## Track & Print:
## A function designed to only print when the particular property has been updated.
var _tracked_values :Dictionary = {}

func track_and_print(object :Object, property_name :String, label :String = "")->bool:
	if not object:
		return false
	var key :Variant = str(object.get_instance_id()) + "_" + property_name
	var current_value :Variant = object.get(property_name)
	if not _tracked_values.has(key):
		_tracked_values[key] = current_value
		print("%s%s = %s (initial)" % [label, property_name, current_value])
		return true
	if _tracked_values[key] != current_value:
		print("%s%s: %s -> %s" % [label, property_name, _tracked_values[key], current_value])
		_tracked_values[key] = current_value
		return true
	return false

#endregion #============================================================# TRACK & PRINT
#region    #============================================================# RegEx

## Removes the digits from a string
## Need
@onready var pattern_that_removes_digits :RegEx = RegEx.new() #Create a new pattern
@onready var pattern_that_lowercases_all :RegEx = RegEx.new()

# _underscore = don't use. Just for init purposes
func _remove_digits_from_string()->Error:
	return pattern_that_removes_digits.compile('\\d')

func remove_digits_from_string(input_string :String)->String:
	return pattern_that_removes_digits.sub(input_string,'',true)

#endregion #============================================================# RegEx
#region    #============================================================# Filters

## Filter -> Return with "Type":
## Takes a node and acts upon it to create a return
var lambda2 :Callable = func(_child1 :Object, _child2 :Object)->void: pass
var lambda1 :Callable = func(_child :Object)->void:pass

func filter1(node :Node, callable1 :Callable, callable2 :Callable=lambda1, callable3 :Callable=lambda1 )->void:
	for child :Node in node.get_children():
		callable1.call(child)
		callable2.call(child)
		callable3.call(child)

func filter2(node :Node, callable1 :Callable, callable2 :Callable=lambda2, callable3 :Callable=lambda2 )->void:
	for child :Node in node.get_children():
		printt(child, callable1)
		callable1.call(node,child)
		callable2.call(node,child)
		callable3.call(node,child)

func filterReturnArray(array :Array, node :Node, callable1 :Callable, callable2 :Callable=lambda1, callable3 :Callable=lambda1 )->Array:
	for child :Node in node.get_children():
		array.append(callable1.call(child))
		array.append(callable2.call(child))
		array.append(callable3.call(child))
	return array

func getChildren_filterDictionary(dictionary :Dictionary, node :Node, callable1 :Callable = lambda1)->Dictionary:
	for child :Node in node.get_children():
		dictionary[child.name] = child
		callable1.call(child)
	return dictionary

#endregion #============================================================# Filters
#region    #============================================================# References




#endregion #============================================================# References
#region    #============================================================# RNG

var rng :RandomNumberGenerator
func _rng()->void:
	rng = RandomNumberGenerator.new()
	rng.randomize()


#endregion #============================================================# RNG
#region    #============================================================# DEBUG

@onready var debug :bool = false
var debug_remove_digits_from_string :Error

func _debug()->void:
	print(debug_remove_digits_from_string)
	assert(global_node_delivery)
	assert(global_node2d_delivery)
	assert(global_delivery)
	assert(deliver_tracks_dictionary)


#endregion #============================================================# DEBUG
