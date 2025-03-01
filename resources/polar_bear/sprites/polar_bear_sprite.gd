extends AnimatedSprite2D #polar_bear_sprite.gd

signal idle_start()
signal sit_start()
signal hit_start()
signal search_start()
signal chase_start()



enum PolarBearActions {Idle,Sit,Hit,Search,Chase}
var current_action :PolarBearActions
@onready var goals :Node = %Goals
@onready var hit :Node = $Hit
@onready var sit :Node = $Sit
@onready var idle :Node = $Idle
@onready var search :Node = $Search
@onready var chase :Node = $Chase

func process_idle()->void:
	play('Idle')

func process_sit()->void:
	play('Sit')

func process_hit()->void:
	play('Hit')
	hit.start()

func process_search()->void:
	play('Move')
	search_start.emit()

func process_chase()->void:
	play('Move')
	chase_start.emit()


func _ready()->void:
	for child in get_children():
		child.set_physics_process(false)
		child.set_process(false)




func _on_hit_finished() -> void:
	print(1)
	hit.unstun()
	search.unstun()
	chase.unstun()
