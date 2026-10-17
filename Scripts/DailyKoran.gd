extends Node2D

@onready var NewspaperBox = $Kantor/NewspaperBox
@onready var koran_ikat: Sprite2D = $Kantor/KoranIkat
@onready var conf: esc_pause_button = $"../PauseButton"

func _random_num() -> void:
	var angka = randi_range(4,8)
	NewspaperBox.set_meta("DailyKoran", angka)
	NewspaperBox.set_meta("CurrentKoran", 0)

func _CooldownKoran(time: float) -> void:
	await get_tree().create_timer(time).timeout

func _ready() -> void:
	_random_num()
	await _CooldownKoran(5)
	koran_ikat.visible = true
