extends Label

var waktu_main: float = 0.0
var timer_jalan: bool = false

func _ready() -> void:
	start_timer()

func _process(delta: float) -> void:
	if timer_jalan:
		waktu_main += delta
		_update_timer()

func _update_timer() -> void:
	var total_detik = int(waktu_main)

	var menit = total_detik / 60
	var detik = total_detik % 60

	text = "%02d:%02d" % [menit, detik]

func start_timer() -> void:
	timer_jalan = true

func stop_timer() -> void:
	timer_jalan = false

func reset_timer() -> void:
	waktu_main = 0.0
	_update_timer()

func restart_timer() -> void:
	reset_timer()
	start_timer()

func get_waktu() -> float:
	return waktu_main

func get_waktu_text() -> String:
	var total_detik = int(waktu_main)

	var menit = total_detik / 60
	var detik = total_detik % 60

	return "%02d:%02d" % [menit, detik]
