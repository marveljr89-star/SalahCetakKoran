extends Panel

var posisi = position
var geser = 0

func _process(delta: float) -> void:
	geser = (get_global_mouse_position() * 4 * delta) 
	position = posisi + geser
