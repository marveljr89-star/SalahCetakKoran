extends GridContainer

@onready var paragraph: RichTextLabel = $"../../KoranUI/Paragraph"
var jwbBenar: PackedStringArray = []
var jwbUnbaku: Array = []

func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	for word in paragraph.words:
		if word.replace(".", "") in paragraph.unbaku_list:
			jwbUnbaku.append(word.replace(".", ""))
			jwbBenar.append(paragraph.baku_list[paragraph.unbaku_list.find(word.replace(".", ""))])
			
	for child in get_children():
		if child is Panel:
			var k = child.get_meta("K", -1)
			var label = child.get_node("Label") as Label
			var line_edit = child.get_node("LineEdit") as LineEdit
			
			if jwbUnbaku.size() > k:
				label.text = jwbUnbaku[k]
				line_edit.text = jwbBenar[k]
				line_edit.visible = true
			else:
				label.text = ""
				line_edit.visible = false
				line_edit.text = ""
