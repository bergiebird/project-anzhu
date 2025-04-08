@icon('res://resources/player/abilities/binos/icons8-binoculars-100.png')
extends Ability #Binos.gd
var north_pressed :bool = false
var south_pressed :bool = false
var east_pressed :bool = false
var west_pressed :bool = false
var spacebar_pressed :bool = false
var direction_count :int
var camera :Camera2D
var camera_movement :Vector2 = Vector2.ZERO

#func _process(delta: float) -> void:
	#if !camera:
		#return
	#var current_north = Input.is_action_pressed("aim_NORTH")
	#var current_south = Input.is_action_pressed("aim_SOUTH")
	#var current_east = Input.is_action_pressed("aim_EAST")
	#var current_west = Input.is_action_pressed("aim_WEST")
	#var current_spacebar = Input.is_action_pressed("spacebar")
#
	#direction_count = 0
	#if current_north: direction_count += 1
	#if current_south: direction_count += 1
	#if current_east: direction_count += 1
	#if current_west: direction_count += 1
#
	#camera_movement = Vector2.ZERO
#
	#if direction_count == 1 and current_spacebar:
		#if current_north and (!north_pressed or !spacebar_pressed):
				#print('north + spacebar combination detected')
		#if current_south and (!south_pressed or !spacebar_pressed):
				#print('south + spacebar combination detected')
		#if current_east and (!east_pressed or !spacebar_pressed):
				#print('east + spacebar combination detected')
		#if current_west and (!west_pressed or !spacebar_pressed):
				#print('west + spacebar combination detected')
#
	#north_pressed = current_north
	#south_pressed = current_south
	#east_pressed = current_east
	#west_pressed = current_west
	#spacebar_pressed = current_spacebar
