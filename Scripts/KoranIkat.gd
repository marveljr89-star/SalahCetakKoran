extends Area2D

@onready var koranAtasMeja: Sprite2D = $"../../KoranAtasMeja"
@onready var parent_node = get_parent()
@onready var buka_koran: AudioStreamPlayer2D = $"../BukaKoran"

var float_tweens: Dictionary = {}

func KoranIkat_on_input_event(viewport: Node, event: InputEvent, shape_ide: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			buka_koran.play()
			parent_node.visible = false
			koranAtasMeja.visible = true
