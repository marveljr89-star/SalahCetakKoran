extends Label

@onready var newspaper_box: Sprite2D = $"../../../Kantor/NewspaperBox"
@onready var cek_hasil: Node2D = $".."

func _process(delta: float) -> void:
	text = "%s/%s" % [cek_hasil.i+1,newspaper_box.get_meta("DailyKoran")]
