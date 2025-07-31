## Libraryton.gd
extends Node

#region    #============================================================# Ready


func _ready()->void:
	debug_remove_digits_from_string = _remove_digits_from_string()
	_rng()
	gloabl_get_emit_dicts()
	_debug()


#endregion

#region    #============================================================# Track Delivery


## Track Delivery Service: Designed to give all SnowTracker Nodes found in Character Scenes
signal deliver_tracks_dictionary(outgoing_tracks :Dictionary[String,Node])
var tracks_dictionary :Dictionary[String,Node]

func set_tracks(incoming_dictionary :Dictionary[String,Node])->void:
	call_deferred("set_tracks_dictionary", incoming_dictionary)
func set_tracks_dictionary(incoming_dictionary:Dictionary[String,Node])->void:
	tracks_dictionary = incoming_dictionary
	deliver_tracks_dictionary.emit(tracks_dictionary)


#endregion

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
	return Lib.Filter.getChildren_filterDictionary( {}, container)


#endregion

#region    #============================================================# RegEx


## Removes the digits from a string
@onready var pattern_that_removes_digits :RegEx = RegEx.new() #Create a new pattern
@onready var pattern_that_lowercases_all :RegEx = RegEx.new()


# _underscore = don't use. Just for init purposes
func _remove_digits_from_string()->Error:
	return pattern_that_removes_digits.compile('\\d')


func remove_digits_from_string(input_string :String)->String:
	return pattern_that_removes_digits.sub(input_string,'',true)


#endregion

#region    #============================================================# RNG


var rng :RandomNumberGenerator

func _rng()->void:
	rng = RandomNumberGenerator.new()
	rng.randomize()


#endregion

#region    #============================================================# DEBUG


var debug_remove_digits_from_string :Error

@onready var debug :bool = false


func _debug()->void:
	print(debug_remove_digits_from_string)
	assert(global_node_delivery)
	assert(global_node2d_delivery)
	assert(global_delivery)
	assert(deliver_tracks_dictionary)


#endregion
