class_name ConfirmationKoran extends Control

signal masukan(ya_masuk: bool)

@onready var tidaksetuju_label: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/tidaksetuju
@onready var setuju_label: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/setuju
@onready var pertanyaan_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Pertanyaan
@onready var warning_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Warning

var _pause: bool = false

func _ready() -> void:
	set_process_unhandled_key_input(false)
	if setuju_label:
		setuju_label.pressed.connect(_setuju_dipencet)
	if tidaksetuju_label:
		tidaksetuju_label.pressed.connect(_tidaksetuju_dipencet)
	hide()

func _tutup_confirmasi_koran(ya_masuk: bool) -> void:
	masukan.emit(ya_masuk)
	hide()
	if _pause:
		get_tree().paused = false
	set_meta("Active", false)

func _checkPause(paused: bool = false) -> bool:
	set_meta("Active", true)
	_pause = (get_tree().paused == false) and paused
	if paused:
		get_tree().paused = true
	show()
	set_process_unhandled_key_input(true)
	return await masukan

func customize(pertanyaan: String, warning: String = "", setuju: String = "Ya", tidaksetuju: String = "Tidak") -> ConfirmationKoran:
	pertanyaan_label.text = pertanyaan
	warning_label.text = warning
	setuju_label.text = setuju
	tidaksetuju_label.text = tidaksetuju
	return self

func _setuju_dipencet() -> void:
	_tutup_confirmasi_koran(true)
	
func _tidaksetuju_dipencet() -> void:
	_tutup_confirmasi_koran(false)
