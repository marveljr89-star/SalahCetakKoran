class_name esc_pause_button extends Control

@onready var lanjutkan: TextureButton = $Preview/VBoxContainer/Lanjutkan
@onready var pengaturan: TextureButton = $Preview/VBoxContainer/Pengaturan
@onready var keluar: TextureButton = $Preview/VBoxContainer/Keluar
@onready var pengaturan_Control: Control = $"../Pengaturan"
@onready var preview: Control = $Preview

@onready var oriPreviewPos = preview.position
@onready var oriPengaturanPos = pengaturan_Control.position

var _pause = false
var slideTween: Dictionary = {}

func _SlideTween(controlA: Control, controlB: Control, current_x: int, target_x: int, current_y: int, target_y: int) -> void:
	if slideTween.has(controlA):
		var old_tween: Tween = slideTween[controlA]
		if old_tween:
			old_tween.kill()

	if slideTween.has(controlB):
		var old_tween: Tween = slideTween[controlB]
		if old_tween:
			old_tween.kill()

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value: float):
			controlA.position.x = value,
		current_x,
		target_x,
		0.2
	)
	tween.parallel().tween_method(
		func(value: float):
			controlB.position.y = value,
		current_y,
		target_y,
		0.2
	)

	slideTween[controlA] = tween
	slideTween[controlB] = tween
	await tween.finished

func _ready() -> void:
	hide()
	pengaturan_Control.closed.connect(_on_pengaturan_closed)

func Lanjutkan_on_lanjutkan_button_down() -> void:
	if self.get_meta("StillAnimate") == false:
		self.set_meta("StillAnimate", true)
		hide()
		get_tree().paused = false
		self.set_meta("StillAnimate", false)

func _on_pengaturan_closed() -> void:
	if pengaturan_Control.get_meta("AlreadyOpen") == false and pengaturan_Control.get_meta("AlreadyClosed") == false:
		pengaturan_Control.slide_in.play()
		pengaturan_Control.set_meta("AlreadyOpen", false)
		pengaturan_Control.set_meta("AlreadyClosed", true)
		await _SlideTween(preview, pengaturan_Control, oriPreviewPos.x - 200, oriPreviewPos.x, 0, oriPengaturanPos.y)
		pengaturan_Control.visible = false

func _on_pengaturan_button_down() -> void:
	if self.get_meta("StillAnimate") == false:
		if pengaturan_Control.get_meta("AlreadyOpen") == false:
			self.set_meta("StillAnimate", true)
			pengaturan_Control.set_meta("AlreadyOpen", true)
			pengaturan_Control.set_meta("AlreadyClosed", false)
			pengaturan_Control.visible = true
			pengaturan_Control.slide_in.play()
			await _SlideTween(preview, pengaturan_Control, oriPreviewPos.x, oriPreviewPos.x - 200, oriPengaturanPos.y, 0)
			self.set_meta("StillAnimate", false)

func Keluar_on_keluar_button_down() -> void:
	if self.get_meta("StillAnimate") == false:
		get_tree().quit()

func _checkPause(paused: bool = false) -> void:
	_pause = (get_tree().paused == false) and paused
	if paused:
		get_tree().paused = true
	show()

func _tutup_confirmasi_koran(cekSumbitKoran: bool) -> void:
	hide()
	if cekSumbitKoran:
		get_tree().paused = false
