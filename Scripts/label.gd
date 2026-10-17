extends Label

var posisi = position
var geser = 0

func _process(delta: float) -> void:
	geser = (get_global_mouse_position() * 2 * delta) 
	position = posisi + geser
