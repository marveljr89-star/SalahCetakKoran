extends Node2D

@onready var stamp_salah: Sprite2D = $StampSalah
@onready var stamp_benar: Sprite2D = $StampBenar
@onready var paragraph: RichTextLabel = $Paragraph
@onready var judul = $Judul
@onready var sheet: Node2D = $"../Sheet"

func _process(delta: float) -> void:
	if get_meta("StampelBenar"):
		stamp_benar.visible = true
		stamp_salah.visible = false
		paragraph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		judul.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif get_meta("StampelSalah"):
		stamp_salah.visible = true
		stamp_benar.visible = false
		paragraph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		judul.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif get_meta("StampelBenar") == false and get_meta("StampelSalah") == false and sheet.z_index == 0:
		paragraph.mouse_filter = Control.MOUSE_FILTER_STOP
		judul.mouse_filter = Control.MOUSE_FILTER_STOP
		stamp_salah.visible = false
		stamp_benar.visible = false
	else:
		stamp_salah.visible = false
		stamp_benar.visible = false
