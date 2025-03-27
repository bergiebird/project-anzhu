extends Node #Libraryton.gd

func _ready()->void:
	set_global_scene_node_dictionary()
#===========================================================
# Track Delivery Service:
# Designed to give all SnowTracker Nodes found in Character Scenes
signal tracks(outgoing_tracks :Dictionary[String,Node])
var tracks_dictionary :Dictionary[String,Node]

func set_tracks(incoming_dictionary :Dictionary[String,Node])->void:
	call_deferred("set_tracks_dictionary", incoming_dictionary)
func set_tracks_dictionary(incoming_dictionary:Dictionary[String,Node])->void:
	tracks_dictionary = incoming_dictionary
	tracks.emit(tracks_dictionary)
# Maybe in the future, I'll have the SnowTracker node handle giving a tilemaplayer node to the main scene so we can
# have multiple animals overlapping their own type's footprints. For now, this works.

#===========================================================
# Global Node Delivery Service:
# Designed to provide anyone with all nodes in a given scene.

signal global_node_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
signal global_node2d_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
signal global_control_delivery(outgoing_global_scene_nodes :Dictionary[String,Node])
@onready var GAME = get_tree().current_scene

func set_global_scene_node_dictionary()->void:
	for root_child in ["NODE","CONTROL","NODE2D"]:
		find_and_deliver_nodes(root_child, Signal(self, "global_" + root_child.to_lower() + "_delivery"))

func find_and_deliver_nodes(what_container:String, delivery_network:Signal)->void:
	var container = GAME.find_child(what_container, true, false)
	var temporary_dictionary :Dictionary[String,Node]
	for child in container.get_children():
		temporary_dictionary[child.name] = child
		for g_child in child.get_children():
			temporary_dictionary[child.name] = child
	delivery_network.emit(container)
	print(container, temporary_dictionary)


# Hella expensive and probably just a general bandaid for now. Some scripts won't need this much information.


#===========================================================
#Track & Print:
# A function designed to only print when the particular property has been updated.

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
