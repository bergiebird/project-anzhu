extends Node #Inputon.gd

var player :Player:
	set(value): #Collect player information on reference setup, for now just the shot decibal level
		if player != value:
			player = value
			abilities = player.abilities
			shot_db = abilities.get_node('Gun').noise_db
var abilities :Abilities
var shot_db :float

func _ready()->void:
	Libraryton.player_reference.connect(func(ref): player = ref)


func look_direction(direction :String)->bool:
	var input = Input.is_action_pressed(Directon.get_aim(direction))
	if input:   
		Directon.set_direction(direction)
	return input

func aim(direction :String)->bool:          return Input.is_action_pressed("aim_" + direction) and Directon.check_direction(direction)
func inverse_move(direction :String)->bool: return move(Directon.OPPOSITE[direction])

func move(direction :String)->bool:         return Input.is_action_pressed("move_" + direction)
func inverse_aim(direction :String)->bool:  return aim(Directon.OPPOSITE[direction])

func jump_pressed()->bool:                  return Input.is_action_just_pressed('jump')
func jump_released()->bool:                 return Input.is_action_just_released("jump")
func modifier()->bool:                      return Input.is_action_just_pressed('spacebar')
func gun_reload()->bool:                    return Input.is_action_just_pressed('gun')
func hide_mouse()->void:                           Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func gun_shoot()->bool:
	var shot :bool = Input.is_action_just_pressed('gun')
	if shot: Signalton.loud_noise.emit(player, player.global_position, shot_db)
	return shot
