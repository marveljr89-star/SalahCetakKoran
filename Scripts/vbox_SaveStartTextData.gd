extends VBoxContainer

var saveTxt: Array = []

func _ready() -> void:
	for child in get_children():
		if child is Label:
			saveTxt.append(child.text)

func _reApply() -> void:
	var i = 0
	for child in get_children():
		if child is Label:
			child.text = saveTxt[i]
			i += 1
