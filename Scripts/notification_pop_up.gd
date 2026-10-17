extends Control

@onready var notifikasi_bar: Sprite2D = $NotifikasiBar
@onready var text_label: Label = $NotifikasiBar/Text
@onready var OriPosx: float = notifikasi_bar.position.x
@onready var notif: Control = $"."
@onready var notif_audio: AudioStreamPlayer2D = $NotifAudio
@onready var pengaturan: Control = $"../Pengaturan"

var slideTween: Dictionary = {}

var typing_speed: float = 0.03
var typing: bool = false
var notif_active: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _SlideTween(sprite: Node2D, current_x: float, Targetx: float) -> void:
	if slideTween.has(sprite):
		var old_tween: Tween = slideTween[sprite]
		if old_tween:
			old_tween.kill()

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value: float):
			sprite.position.x = value,
		current_x,
		Targetx,
		0.2
	)

	slideTween[sprite] = tween
	await tween.finished


func show_text_one_by_one(new_text: String) -> void:
	typing = true

	text_label.text = new_text
	text_label.visible_characters = 0
	fit_text_to_label(text_label, new_text, 155, 10)

	for i in range(text_label.text.length()):
		text_label.visible_characters += 1
		await get_tree().create_timer(typing_speed).timeout

	typing = false

func fit_text_to_label(label: Label, new_text: String, max_font_size: int = 155, min_font_size: int = 10) -> void:
	label.text = new_text
	var font = label.get_theme_font("font")

	for size in range(max_font_size, min_font_size - 1, -1):
		var text_width = font.get_string_size(
			label.text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			size
		).x

		if text_width <= label.size.x:
			print("Berhasil")
			label.add_theme_font_size_override("font_size", size)
			return

	label.add_theme_font_size_override("font_size", min_font_size)

func closeNotif() -> void:
	await _SlideTween(
		notifikasi_bar,
		OriPosx,
		OriPosx - 1000
	)

	notif.visible = false
	notif_active = false

func Active(new_text: String) -> void:
	if notif_active:
		return
	if PengaturanData.notif == false:
		return
		
	notif_audio.play()
	notif_active = true
	notif.visible = true

	notifikasi_bar.position.x = OriPosx + 1000

	await _SlideTween(
		notifikasi_bar,
		notifikasi_bar.position.x,
		OriPosx
	)
	await show_text_one_by_one(new_text)
	await get_tree().create_timer(1.0).timeout
	await closeNotif()
