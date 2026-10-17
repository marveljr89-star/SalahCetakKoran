extends Sprite2D

@onready var label = $Label

func _process(delta: float) -> void:
	var current = get_meta("CurrentKoran")
	var require = get_meta("DailyKoran")
	label.text = "%s/%s" % [current, require]
