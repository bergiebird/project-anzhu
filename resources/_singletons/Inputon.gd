extends Node #Inputon.gd

@onready var inverted_directionary = {
	 "SOUTH":"NORTH",
	 "NORTH":"SOUTH",
	 "EAST":"WEST",
	 "WEST":"EAST",
}

func move(direction :String)->bool:return Input.is_action_pressed("move_" + direction)

func aim(direction :String)->bool: return Input.is_action_pressed("aim_" + direction)

func inverse_move(direction :String)->bool: return move(inverted_directionary[direction])

func inverse_aim(direction :String)->bool: return aim(inverted_directionary[direction])

func jump_pressed()->bool: return Input.is_action_just_pressed('jump')

func jump_released()->bool: return Input.is_action_just_released("jump")

func modifier()->bool: return Input.is_action_just_pressed('spacebar')

func gun()->bool:   return Input.is_action_just_pressed('gun')

func hide_mouse()->void:  Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
