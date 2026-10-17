extends CheckButton

@onready var pengaturan: Control = $"../.."

func _ready() -> void:
	if PengaturanData.notif == false:
		self.button_pressed = true

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		PengaturanData.notif = false
	else:
		PengaturanData.notif = true
