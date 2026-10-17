extends Sprite2D

@onready var koran_atas_meja: Sprite2D = $"../KoranAtasMeja"
@onready var conf: ConfirmationKoran = $"../../../SumbitKoran"
@onready var koran_ikat: Sprite2D = $"../KoranIkat"
@onready var newTexture = preload("res://Asset/telepon (empty).png")
@onready var normalTexture = preload("res://Asset/kerangka telepon.png")
@onready var notif: Control = $"../../../Notif"

var Telephone_dipakai: bool = false

func _change_texture() -> void:
	if texture == newTexture:
		texture = normalTexture
	elif texture == normalTexture:
		texture = newTexture

func _change_koran() -> void:
	await koran_atas_meja._clearKoran()
	await koran_atas_meja.spawn_koran()
	await get_tree().create_timer(3).timeout
	koran_ikat.visible = true
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			conf.customize(
				"Ingin Menggunakan Telephone?",
				"Setelah Menggunakan Telephone tidak bisa di pakai sampai hari selanjutnya!",
				"Ya",
				"Tidak"
			)
			var jawaban = await conf._checkPause(true)
			if jawaban:
				if koran_ikat.visible == true or koran_atas_meja.visible == true:
					if Telephone_dipakai:
						notif.Active("Telephone sudah dipakai hari ini")
						return
					else:
						Telephone_dipakai = true
						koran_atas_meja.visible = false
						koran_ikat.visible = false
						_change_texture()
						notif.Active("Telephone membantu mengganti koran")
						await _change_koran()
				else:
					notif.Active("Koran Belum muncul")
			else:
				print("Tidak jadi ah")
