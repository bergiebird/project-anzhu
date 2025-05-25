extends ColorRect
class_name CRT

@onready var parent = get_parent()
@onready var grandparent = parent.get_parent()

func _ready():
	grandparent.crt_visibility.connect(func(bol): visible = bol)
	grandparent.debug_view = grandparent.debug_view
