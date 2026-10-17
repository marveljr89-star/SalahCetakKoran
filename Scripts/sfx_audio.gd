extends HSlider

@export var audio_bus_name: String
@onready var angka: Label = $Angka

var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	value = PengaturanData.SFXValue
	var db = linear_to_db(PengaturanData.SFXValue)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
	angka.text = str(int(PengaturanData.SFXValue*100))

func _on_value_changed(value: float) -> void:
	PengaturanData.SFXValue = value
	var db = linear_to_db(PengaturanData.SFXValue)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
	angka.text = str(int(PengaturanData.SFXValue*100))
