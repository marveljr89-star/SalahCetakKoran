extends VBoxContainer

var posisi = position
var geser = 0

func _process(delta: float) -> void:
	geser = (get_global_mouse_position() * delta) 
	position = posisi + geser
