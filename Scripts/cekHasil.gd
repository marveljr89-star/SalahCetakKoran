extends Node2D

@onready var koran_ui: Node2D = $Tempat/KoranUI
@onready var paragraph: RichTextLabel = $Tempat/KoranUI/Paragraph
@onready var judul: Label = $Tempat/KoranUI/Judul
@onready var koran_atas_meja: Sprite2D = $"../../Kantor/KoranAtasMeja"
@onready var sheetGrid: GridContainer = $Tempat/Sheet/GridContainer
@onready var jawabGrid: GridContainer = $Tempat/SheetJawab/GridContainer
@onready var tempat: Node2D = $Tempat
@onready var kiri_tombol: TextureButton = $KiriTombol
@onready var kanan_tombol: TextureButton = $KananTombol
@onready var OriPosx = tempat.position.x
@onready var audio_slide: AudioStreamPlayer2D = $AudioSlide
@onready var hover_audio: AudioStreamPlayer2D = $HoverAudio

var i: int = 0
var arrayData: Array = []
var slideTween: Dictionary = {}

func _showAnswers(index: int) -> void:
	var dictData = arrayData[index]
	var sheetData = dictData["sheet"]
	var jawabData = dictData["sheet_jawab"]
	judul.text = dictData["judul"]
	paragraph.text = dictData["paragraph"]
	koran_ui.set_meta("StampelBenar", dictData["StampelBenar"])
	koran_ui.set_meta("StampelSalah", dictData["StampelSalah"])
	
	for child in sheetGrid.get_children():
		if child is Panel:
			var k = child.get_meta("K", -1)
			var label = child.get_node("Label") as Label
			var line_edit = child.get_node("LineEdit") as LineEdit
			var Arrow = child.get_node("Arrow") as Sprite2D
			var data = sheetData[k]
			
			if data["label"] != "":
				label.text = data["label"]
				line_edit.text = data["line_edit"]
				line_edit.visible = true
				Arrow.visible = true
			else:
				label.text = ""
				line_edit.visible = false
				line_edit.text = ""
				Arrow.visible = false
				
	for child in jawabGrid.get_children():
		if child is Panel:
			var k = child.get_meta("K", -1)
			var label = child.get_node("Label") as Label
			var line_edit = child.get_node("LineEdit") as LineEdit
			var Arrow = child.get_node("Arrow") as Sprite2D
			var data = jawabData[k]
			
			if data["label"] != "":
				label.text = data["label"]
				line_edit.text = data["line_edit"]
				line_edit.visible = true
				Arrow.visible = true
			else:
				label.text = ""
				line_edit.visible = false
				line_edit.text = ""
				Arrow.visible = false

func _SlideTween(sprite: Node2D, current_x: int, Targetx: int) -> void:
	audio_slide.play()
	if slideTween.has(sprite):
		var old_tween: Tween = slideTween[sprite]
		if old_tween:
			old_tween.kill()

	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value: float):
			sprite.position.x = value,
		current_x,
		Targetx,
		0.2
	)
	
	slideTween[sprite] = tween
	await tween.finished

func _on_texture_button_pressed_right() -> void:
	if kanan_tombol.get_meta("AnimatedDone", true):
		if i < arrayData.size() - 1:
			hover_audio.play()
			kanan_tombol.set_meta("AnimatedDone", false)
			i += 1
			await _SlideTween(tempat, OriPosx, OriPosx - 1100)
			_showAnswers(i)
			await _SlideTween(tempat, OriPosx + 1100, OriPosx)
			kanan_tombol.set_meta("AnimatedDone", true)

func _on_texture_button_pressed_left() -> void:
	if kiri_tombol.get_meta("AnimatedDone", true):
		if i > 0:
			hover_audio.play()
			kiri_tombol.set_meta("AnimatedDone", false)
			i -= 1
			await _SlideTween(tempat, OriPosx, OriPosx + 1100)
			_showAnswers(i)
			await _SlideTween(tempat, OriPosx - 1100, OriPosx)
			kiri_tombol.set_meta("AnimatedDone", true)


func _on_cek_hasil_press_open() -> void:
	i = 0
	arrayData = koran_atas_meja.submit_koran_data.duplicate(true)
	print("Jumlah koran hasil: ", arrayData.size())
	if !arrayData.is_empty():
		_showAnswers(i)
	
func _NextDay() -> void:
	i = 0
	arrayData.clear()
