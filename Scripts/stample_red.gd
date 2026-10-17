extends Sprite2D

@onready var koran_atas_meja: Sprite2D = $"../KoranAtasMeja"
@onready var OriPos = koran_atas_meja.position
@onready var conf: ConfirmationKoran = $"../../../SumbitKoran"
@onready var stamp: AudioStreamPlayer2D = $Stamp

var is_holding = false
var is_dragging = false

var is_inside_Koran = false

var press_mouse_pos = Vector2.ZERO
const DRAG_THRESHOLD = 2.0

var slideTween: Dictionary = {}

func _get_koran_instance() -> Node2D:
	if !is_instance_valid(koran_atas_meja.koran_instance):
		return null
	return koran_atas_meja.koran_instance

func _get_koran_ui() -> Node2D:
	var instance = _get_koran_instance()
	if instance == null:
		return null
	return instance.get_node_or_null("KoranUI") as Node2D

func HoldClick_on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_meta("AnimatedDone", true):
				is_holding = true
				is_dragging = false
				press_mouse_pos = get_global_mouse_position()
				z_index = 1

func _SlideTween(sprite: Node2D, current_y: float, Targety: float) -> void:
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
		Targety,
		1
	)

	slideTween[sprite] = tween
	await tween.finished

func _confirm_stampel() -> void:
	conf.customize(
		"Yakin mau stampel?",
		"Setelah di stampel kamu tidak bisa cari kata tidak baku lagi!!",
		"Ya",
		"Tidak"
	)
	
	var jawaban = await conf._checkPause(true)
	if jawaban:
		var koranUI = _get_koran_ui()
		if koranUI == null:
			return
		koranUI.set_meta("StampelSalah", true)
		koranUI.set_meta("StampelBenar", false)
		
		position = koran_atas_meja.position
		position.y -= 50
		var posisi_awal = position.y
		await _SlideTween(
			self,
			posisi_awal,
			posisi_awal + 50
		)
		stamp.play()
		await _SlideTween(
			self,
			posisi_awal + 50,
			posisi_awal
		)
		koran_atas_meja.set_interaction_enabled(true)
		set_meta("AnimatedDone", true)
		set_meta("AnimFloatHold", false)
		get_parent().reActive(self)
	else:
		koran_atas_meja.set_interaction_enabled(true)
		set_meta("AnimatedDone", true)
		set_meta("AnimFloatHold", false)
		get_parent().reActive(self)
		print("Tidak jadi")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			if is_holding:
				is_holding = false
				is_dragging = false
				var instance = _get_koran_instance()
				if instance != null:
					var koranUI = _get_koran_ui()
					if (is_inside_Koran and koran_atas_meja.visible and !koranUI.get_meta("StampelSalah", false)):
						koran_atas_meja.set_interaction_enabled(false)
						set_meta("AnimatedDone", false)
						set_meta("AnimFloatHold", true)
						get_parent().stop_float(self)
						get_parent().stop_outline(self)
						await _confirm_stampel()
					elif instance.get_meta("StampelBenar", false):
						pass

func _process(delta: float) -> void:
	if is_holding:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.distance_to(press_mouse_pos) > DRAG_THRESHOLD:
			is_dragging = true
		if is_dragging:
			global_position = mouse_pos
	else:
		if get_meta("AnimatedDone", true) == false:
			z_index = 1
		else:
			z_index = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("KoranAtasMeja"):
		is_inside_Koran = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("KoranAtasMeja"):
		is_inside_Koran = false
