extends Control

signal closed
@onready var slide_in: AudioStreamPlayer2D = $SlideIn


func _on_button_pressed() -> void:
	set_meta("AlreadyOpen", false)

	closed.emit()
