extends CheckButton

func _ready() -> void:
	if PengaturanData.fullScreen == true:
		self.button_pressed = true

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		PengaturanData.fullScreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		PengaturanData.fullScreen == false
