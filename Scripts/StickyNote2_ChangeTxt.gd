extends Sprite2D

@onready var label: Label = $Label

func _process(delta: float) -> void:
	var day = get_meta("DAY")
	label.text = "DAY %s" % [day]
