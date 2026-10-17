extends NinePatchRect

@onready var koran_atas_meja: Sprite2D = $"../../Kantor/KoranAtasMeja"
@onready var day_indicator: Sprite2D = $"../../Kantor/DayIndicator"
@onready var day: Label = $Day
@onready var vbox: VBoxContainer = $Vbox
@onready var waktu: Label = $"../../Waktu"
@onready var coffee: Sprite2D = $"../../Kantor/Coffee"
@onready var cek_hasil: Node2D = $"../CekHasil"
@onready var hover_audio: AudioStreamPlayer2D = $HoverAudio

@onready var stampel_benar_label: Label = $Vbox/StampelBenar
@onready var koran_di_stampel_label: Label = $Vbox/KoranDiStampel
@onready var tidak_baku_ketemu_label: Label = $Vbox/TidakBakuKetemu
@onready var un_baku_ke_baku_benar_label: Label = $Vbox/UnBakuKeBakuBenar
@onready var baku_terpilih_label: Label = $Vbox/BakuTerpilih
@onready var waktu_label: Label = $Vbox/Waktu


var arrayData: Array = []
var StampBenar: int = 0
var KoranStampel: int = 0
var FoundUnBaku: int = 0
var UnBakutoBakuBenar: int = 0
var BakuClicked: int = 0
var jumlahUnBaku: int = 0

func _stars(star: int) -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			var k = child.get_meta("K", -1)
			if star >= k:
				child.play("Star")
			else:
				child.play("noStar")

func _cekStampel() -> void:
	for i in range(arrayData.size()):
		var cekStamp = true
		var dic = arrayData[i]
		var smpBenar = dic["StampelBenar"]
		var smpSalah = dic["StampelSalah"]
		var sheetJawab = dic["sheet_jawab"]
		for j in range(sheetJawab.size()):
			var Sheet = sheetJawab[j]
			if Sheet["label"] != "":
				cekStamp = false
		
		if cekStamp and smpBenar:
			StampBenar += 1
			KoranStampel += 1
		elif !cekStamp and smpSalah:
			StampBenar += 1
			KoranStampel += 1
		elif smpBenar:
			KoranStampel += 1
		elif smpSalah:
			KoranStampel += 1
		else:
			continue

func _TidakBaku_ketemu_cekBakuBenar_bakuClicked() -> void:
	for i in range(arrayData.size()):
		var dic = arrayData[i]
		var sheet = dic["sheet"]
		var sheetJawab = dic["sheet_jawab"]
		var curBaku = 0
		var adaIsi = 0
		for data in sheet:
			if data["label"] != "":
				adaIsi += 1
		for j in range(sheetJawab.size()):
			if sheetJawab[j]["label"] == "":
				continue
			jumlahUnBaku += 1
			for k in range(sheet.size()):
				if sheet[k]["label"] == "":
					continue
				if sheetJawab[j]["label"] == sheet[k]["label"]:
					FoundUnBaku += 1
					curBaku += 1
					if sheetJawab[j]["line_edit"] == sheet[k]["line_edit"]:
						UnBakutoBakuBenar += 1
					break
		BakuClicked += adaIsi - curBaku

func _ChangeText(num: int, text: String) -> String:
	var newString = ""
	for i in range(text.length()):
		if text[i] == "0":
			newString += str(num)
		else:
			newString += text[i]
	return newString

func _cekAllData() -> void:
	StampBenar = 0
	KoranStampel = 0
	FoundUnBaku = 0
	UnBakutoBakuBenar = 0
	BakuClicked = 0
	jumlahUnBaku = 0
	set_meta("JumlahBenar", 0)

	_cekStampel()
	_TidakBaku_ketemu_cekBakuBenar_bakuClicked()
	if StampBenar == arrayData.size() or KoranStampel == arrayData.size() or FoundUnBaku == jumlahUnBaku or UnBakutoBakuBenar == jumlahUnBaku or BakuClicked == 0:
		set_meta("JumlahBenar", get_meta("JumlahBenar") + 1)

	stampel_benar_label.text = _ChangeText(StampBenar, stampel_benar_label.text)
	koran_di_stampel_label.text = _ChangeText(KoranStampel, koran_di_stampel_label.text)
	tidak_baku_ketemu_label.text = _ChangeText(FoundUnBaku, tidak_baku_ketemu_label.text)
	un_baku_ke_baku_benar_label.text = _ChangeText(UnBakutoBakuBenar, un_baku_ke_baku_benar_label.text)
	baku_terpilih_label.text = _ChangeText(BakuClicked, baku_terpilih_label.text)
	waktu_label.text = "-Waktu- %s" % [waktu.get_waktu_text()]
	
	if get_meta("JumlahBenar") > 4:
		_stars(3)
	else:
		_stars(get_meta("JumlahBenar")/2)
	
func _StartGetData() -> void:
	arrayData = koran_atas_meja.submit_koran_data
	day.text = "HARI %s" % [day_indicator.get_meta("DAY")]
	_cekAllData()

func _on_next_day_button_down() -> void:
	hover_audio.play()
	vbox._reApply()
	day_indicator.set_meta("DAY", day_indicator.get_meta("DAY") + 1)
	get_parent().visible = false
	get_parent().get_parent()._random_num()
	koran_atas_meja._NextDay()
	cek_hasil._NextDay()
	waktu.restart_timer()
	coffee.kopi_dipakai = false
	coffee._change_texture()
