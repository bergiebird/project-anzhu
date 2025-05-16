extends Node #Inputon.gd

signal cursor_movement_report(bol :bool)

var player :Player:
	set(value): #Collect player information on reference setup, for now just the shot decibal level
		if player != value:
			player = value
			abilities = player.abilities
var abilities :Abilities
var shot_db :float

func _ready()->void:
	Libraryton.player_reference.connect(func(ref :Player)->void: player = ref)

func look_direction(direction :String)->bool:
	return true if Input.is_action_pressed(Directon.get_aim(direction)) else false

func aim(direction :String)->bool:
	return Input.is_action_pressed("aim_" + direction)

func inverse_move(direction :String)->bool:
	return move(Directon.OPPOSITE[direction])

func move(direction :String)->bool:
	return Input.is_action_pressed("move_" + direction)

func inverse_aim(direction :String)->bool:
	return aim(Directon.OPPOSITE[direction])

func jump_pressed()->bool:
	return Input.is_action_just_pressed('jump')

func jump_released()->bool:
	return Input.is_action_just_released("jump")

func modifier()->bool:
	return Input.is_action_just_pressed('spacebar')

func gun_reload()->bool:
	return Input.is_action_just_pressed('gun')

func escape()->bool:
	return Input.is_action_just_released("esc")

func hide_cursor()->void:
	cursor_movement_report.emit(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
func reveal_cursor()->void:
	cursor_movement_report.emit(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func gun_shoot()->bool:
	var shot :bool = Input.is_action_just_pressed('gun')
	if shot:
		Signalton.loud_noise.emit(player, player.global_position, shot_db)
	return shot

func left_mouse_release()->bool:
	return Input.is_action_just_released("left_click")
