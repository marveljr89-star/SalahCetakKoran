extends GridContainer

@onready var paragraph: RichTextLabel = $"../../KoranUI/Paragraph"

var answers: Array = ["","","","","",""]

func _on_paragraph_meta_clicked(_meta: Variant) -> void:
	await get_tree().create_timer(0.01).timeout
	for child in get_children():
		if child is Panel:
			var k = child.get_meta("K", -1)
			var label = child.get_node("Label") as Label
			var line_edit = child.get_node("LineEdit") as LineEdit
			var button = child.get_node("TextureButton") as TextureButton
			var Arrow = child.get_node("Arrow") as Sprite2D

			if paragraph.clicked.size() > k:
				if label.text != paragraph.clicked[k]:
					line_edit.text = ""
					answers[k] = ""
				label.text = paragraph.clicked[k]
				line_edit.visible = true
				button.visible = true
				Arrow.visible = true
			else:
				label.text = ""
				line_edit.visible = false
				line_edit.text = ""
				button.visible = false
				Arrow.visible = false
				answers[k] = ""

func _ready() -> void:
	for child in get_children():
		if child is Panel:
			var k = child.get_meta("K", -1)
			var label = child.get_node("Label") as Label
			var line_edit = child.get_node("LineEdit") as LineEdit
			var button = child.get_node("TextureButton") as TextureButton

			line_edit.text_changed.connect(
				func(new_text: String):
					_on_line_edit_text_changed(k, new_text)
			)
			
			button.pressed.connect(
				func(word = label.text):
					_on_button_pressed(word)
			)

func _on_button_pressed(word: String) -> void:
	print("a", word)
	paragraph.clicked.erase(word)
	_on_paragraph_meta_clicked("ts no need")

func _on_line_edit_text_changed(k: int, new_text: String) -> void:
	answers[k] = new_text

	print("Slot ", k, " = ", new_text)
