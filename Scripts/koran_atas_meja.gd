extends Sprite2D

const koran_scene = preload("res://Scene/koran.tscn")
var normal_texture = preload("res://Asset/KoranAboveMeja.png")
var new_texture = preload("res://Asset/KoranLipat.png")
@onready var conf: ConfirmationKoran = $"../../../SumbitKoran"
@onready var DailyKoran: Node2D = $"../.."
@onready var newspaper_box: Sprite2D = $"../NewspaperBox"
@onready var koran_ikat: Sprite2D = $"../KoranIkat"
@onready var tunjukan_hasil: Node2D = $"../../TunjukanHasil"
@onready var waktu: Label = $"../../Waktu"
@onready var game: Node2D = $"../.."
@onready var notif: Control = $"../../../Notif"
@onready var audio_buka_koran: AudioStreamPlayer2D = $AudioBukaKoran
@onready var koran_masuk_box: AudioStreamPlayer2D = $KoranMasukBox

var koran_instance: Node2D = null
@onready var grandparent = get_parent().get_parent()

var is_holding = false
var is_dragging = false

var press_mouse_pos = Vector2.ZERO
const DRAG_THRESHOLD = 8.0

var is_inside_newspaper_box = false

var submit_koran_data: Array = []
var Koran_Anim: Dictionary = {}

func spawn_koran():
	set_meta("KoranOpen", false)
	koran_instance = koran_scene.instantiate()
	koran_instance.koran_atas_meja = self
	var koran_ui = koran_instance.get_node("KoranUI") as Node2D
	koran_ui.set_meta("StampelBenar", false)
	koran_ui.set_meta("StampelSalah", false)
	koran_instance.position = Vector2(830, 320)
	koran_instance.scale = Vector2(1.75, 1.75)
	koran_instance.visible = false
	grandparent.call_deferred("add_child", koran_instance)

func _ready() -> void:
	spawn_koran()

func HoldClick_on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_meta("AnimatedDone", true):
				is_holding = true
				is_dragging = false
				press_mouse_pos = get_global_mouse_position()

func _KoranInstanceTween(sprite: Node2D) -> void:
	if Koran_Anim.has(sprite):
		var old_tween: Tween = Koran_Anim[sprite]
		if old_tween:
			old_tween.kill()

	var current_x = sprite.position.x
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value: float):
			sprite.position.x = value,
		current_x + 500,
		current_x,
		0.2
	)
	
	Koran_Anim[sprite] = tween
	await tween.finished

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			
			if is_holding:
				var was_dragging = is_dragging
				if !was_dragging:
					if get_meta("AnimatedDone", true) and koran_instance.get_meta("AnimatedDone", true) and get_meta("KoranOpen") == false:
						if koran_instance != null:
							audio_buka_koran.play()
							koran_instance.visible = true
							set_meta("KoranOpen", true)
							set_meta("AnimatedDone", false)
							await _KoranInstanceTween(koran_instance)
							set_meta("AnimatedDone", true)
				elif is_inside_newspaper_box:
					_confirm_insert_koran()
			
			is_holding = false
			is_dragging = false

func set_interaction_enabled(enabled: bool) -> void:
	set_meta("AnimatedDone", enabled)

	if !enabled:
		is_holding = false
		is_dragging = false

func _process(delta: float) -> void:
	if !get_meta("AnimatedDone", true):
		return

	if is_holding:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.distance_to(press_mouse_pos) > DRAG_THRESHOLD:
			is_dragging = true
		if is_dragging:
			global_position = mouse_pos

func _get_grid_data(grid: GridContainer) -> Array:
	var result: Array = []

	for slot in grid.get_children():
		var label = slot.find_child("Label", true, false) as Label
		var line_edit = slot.find_child("LineEdit", true, false) as LineEdit

		var slot_data = {
			"label": "",
			"line_edit": ""
		}

		if label:
			slot_data["label"] = label.text
		if line_edit:
			slot_data["line_edit"] = line_edit.text

		result.append(slot_data)

	return result

func _remove_URl_koran(paragraph: RichTextLabel) -> String:
	var kurung = false
	var newTxt = ""
	for i in range(paragraph.text.length()):
		if paragraph.text[i] == "[":
			kurung = true
			continue
		elif paragraph.text[i] == "]":
			kurung = false
			continue
		if kurung == false:
			newTxt += paragraph.text[i]
	return newTxt

func _save_current_koran() -> void:
	if !is_instance_valid(koran_instance):
		return

	var ui = koran_instance

	var KoranUI = ui.get_node("KoranUI") as Node2D
	var paragraph = ui.get_node("KoranUI/Paragraph") as RichTextLabel
	var judul = ui.get_node("KoranUI/Judul") as RichTextLabel

	var sheet_grid = ui.get_node("Sheet/GridContainer") as GridContainer
	var sheet_jawab_grid = ui.get_node("SheetJawab/GridContainer") as GridContainer

	var data = {
		"StampelBenar": KoranUI.get_meta("StampelBenar", false),
		"StampelSalah": KoranUI.get_meta("StampelSalah", false),
		"judul": judul.text,
		"paragraph": _remove_URl_koran(paragraph),

		"sheet": _get_grid_data(sheet_grid),
		"sheet_jawab": _get_grid_data(sheet_jawab_grid)
	}

	submit_koran_data.append(data)

	print("Koran disimpan:")
	print(data)

func _cekDailyKoranReq() -> void:
	if newspaper_box.get_meta("CurrentKoran") < newspaper_box.get_meta("DailyKoran"):
		koran_ikat.visible = true
		spawn_koran()
	else:
		tunjukan_hasil.get_node("Results")._StartGetData()
		waktu.stop_timer()
		tunjukan_hasil.visible = true

func _clearKoran() -> void:
	if is_instance_valid(koran_instance):
		var old_koran = koran_instance
		koran_instance = null
		old_koran.queue_free()
		await old_koran.tree_exited
			
func _confirm_insert_koran() -> void:
	conf.customize(
		"Masukan Koran?",
		"Setelah dimasukan tidak bisa di keluarkan lagi!",
		"Ya",
		"Tidak"
	)
	var jawaban = await conf._checkPause(true)
	if jawaban:
		newspaper_box.set_meta("CurrentKoran", newspaper_box.get_meta("CurrentKoran") + 1)

		if is_instance_valid(koran_instance):
			_save_current_koran()
			_clearKoran()
			koran_masuk_box.play()
		
		print("Size di Array saat ini : ", submit_koran_data.size())
		visible = false
		await game._CooldownKoran(5)
		_cekDailyKoranReq()
	else:
		print("Tidak jadi")

func _NextDay() -> void:
	submit_koran_data.clear()
	await game._CooldownKoran(5)
	koran_ikat.visible = true
	spawn_koran()

func _on_area_2d_masukin_koran_area_entered(area: Area2D) -> void:
	if area.is_in_group("NewspaperBox"):
		is_inside_newspaper_box = true
		texture = new_texture

func _on_area_2d_masukin_koran_area_exited(area: Area2D) -> void:
	if area.is_in_group("NewspaperBox"):
		is_inside_newspaper_box = false
		texture = normal_texture
