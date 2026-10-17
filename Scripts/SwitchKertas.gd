extends Area2D

@onready var grandparent = get_parent().get_parent()
@onready var audio_koran: AudioStreamPlayer2D = $"../../AudioKoran"

func _on_input_event_Clicked(viewport: Node, event: InputEvent, shape_ide: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			audio_koran.play()
			var koran = grandparent.find_child("KoranUI") as Node2D
			var kertas_jawab = grandparent.find_child("Sheet") as Node2D
			var paragraph = koran.find_child("Paragraph") as RichTextLabel
			var judul = koran.find_child("Judul") as RichTextLabel
			
			var temp_position = koran.position
			koran.position = kertas_jawab.position
			kertas_jawab.position = temp_position
			
			if kertas_jawab.z_index != 1:
				kertas_jawab.z_index = 1
				kertas_jawab.find_child("GridContainer").z_index = 1
				paragraph.mouse_filter = Control.MOUSE_FILTER_IGNORE
				judul.mouse_filter = Control.MOUSE_FILTER_IGNORE
			else:
				kertas_jawab.z_index = 0
				kertas_jawab.find_child("GridContainer").z_index = 0
