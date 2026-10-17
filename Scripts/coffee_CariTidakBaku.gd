extends Sprite2D

@onready var koran_atas_meja: Sprite2D = $"../KoranAtasMeja"
@onready var conf: ConfirmationKoran = $"../../../SumbitKoran"
@onready var koran_ikat: Sprite2D = $"../KoranIkat"
@onready var newTexture = preload("res://Asset/coffee_mug (empty).png")
@onready var normalTexture = preload("res://Asset/coffee_mug.png")
@onready var notif: Control = $"../../../Notif"

var kopi_dipakai: bool = false


func _get_paragraph() -> RichTextLabel:
	if !is_instance_valid(koran_atas_meja.koran_instance):
		return null

	return koran_atas_meja.koran_instance.get_node_or_null("KoranUI/Paragraph") as RichTextLabel

func _change_texture() -> void:
	if texture == newTexture:
		texture = normalTexture
	elif texture == normalTexture:
		texture = newTexture

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			conf.customize(
				"Ingin Minum Kopi?",
				"Setelah minum tidak bisa di pakai sampai hari selanjutnya!",
				"Ya",
				"Tidak"
			)
			var jawaban = await conf._checkPause(true)
			if jawaban:
				if koran_atas_meja.visible == true:
					if kopi_dipakai:
						notif.Active("Kopi sudah dipakai hari ini")
						return

					var paragraph = _get_paragraph()

					if paragraph == null:
						notif.Active("Koran belum tersedia")
						return

					var berhasil = await paragraph.bantuan_kopi()

					if berhasil:
						kopi_dipakai = true
						_change_texture()
						notif.Active("Kopi membantu menemukan 1 kata tidak baku")
					else:
						notif.Active("Tidak ada kata yang bisa dibantu")
				elif koran_ikat.visible == true:
					notif.Active("Koran belum di buka")
				else:
					notif.Active("Koran belum muncul")
			else:
				print("Tidak jadi ah")
