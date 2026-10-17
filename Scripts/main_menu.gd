extends Control

@onready var pengaturan: Control = $Pengaturan
@onready var panel_2: Panel = $Panel2

@onready var pengaturan_oriPos: Vector2 = pengaturan.position
@onready var previewKoran_oriPos: Vector2 = panel_2.position

var slideTween: Dictionary = {}

@onready var posisi = pengaturan.position
var geser = 0

func _process(delta: float) -> void:
	geser = (get_global_mouse_position() * delta) 
	pengaturan.position = posisi + geser

func _SlideTween(sprite: Control, current_y: float, target_y: float) -> void:
	if slideTween.has(sprite):
		var old_tween: Tween = slideTween[sprite]
		if old_tween:
			old_tween.kill()

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value: float):
			sprite.position.y = value,
		current_y,
		target_y,
		0.2
	)

	slideTween[sprite] = tween
	await tween.finished

func _on_pengaturan_closed() -> void:
	pengaturan.slide_in.play()
	await _SlideTween(
		pengaturan,
		pengaturan.position.y,
		pengaturan_oriPos.y - 800
	)

	pengaturan.visible = false
	panel_2.position.y = previewKoran_oriPos.y + 800
	panel_2.visible = true
	
	await _SlideTween(
		panel_2,
		panel_2.position.y,
		previewKoran_oriPos.y
	)

	pengaturan.set_meta("AlreadyClosed", true)

func _ready() -> void:
	pengaturan.position.y = pengaturan_oriPos.y - 800
	panel_2.position = previewKoran_oriPos

	pengaturan.set_meta("AlreadyOpen", false)
	pengaturan.set_meta("AlreadyClosed", true)

	panel_2.visible = true
	pengaturan.visible = false

	pengaturan.closed.connect(_on_pengaturan_closed)

func tombol_mulai_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/dunia.tscn")

func tombol_pengaturan_pressed() -> void:
	if pengaturan.get_meta("AlreadyOpen", false):
		return
	
	panel_2.position = previewKoran_oriPos
	await _SlideTween(
		panel_2,
		previewKoran_oriPos.y,
		panel_2.position.y + 800
	)
	panel_2.visible = false
	pengaturan.visible = true
	pengaturan.position.y = pengaturan_oriPos.y - 800
	pengaturan.slide_in.play()
	await _SlideTween(
		pengaturan,
		pengaturan.position.y,
		pengaturan_oriPos.y
	)

	pengaturan.set_meta("AlreadyOpen", true)
	pengaturan.set_meta("AlreadyClosed", false)


func tombol_keluar_pressed() -> void:
	get_tree().quit()
