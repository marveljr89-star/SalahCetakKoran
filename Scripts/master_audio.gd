extends HSlider

@export var audio_bus_name: String
@onready var angka: Label = $Angka

var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	value = PengaturanData.MasterValue
	var db = linear_to_db(PengaturanData.MasterValue)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
	angka.text = str(int(PengaturanData.MasterValue*100))

func _on_value_changed(value: float) -> void:
	PengaturanData.MasterValue = value
	var db = linear_to_db(PengaturanData.MasterValue)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
	angka.text = str(int(PengaturanData.MasterValue*100))
