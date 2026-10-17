extends RichTextLabel

@onready var Judul: RichTextLabel = $"../Judul"
@onready var grid_container: GridContainer = $"../../Sheet/GridContainer"
@onready var mengarsir_text: AudioStreamPlayer2D = $"../MengarsirText"

const baku_list = [
	"ramai",
	"senang",
	"sangat",
	"lelah",
	"mengatakan",
	"seperti",
	"tidak",
	"futuristis",
	"sudah",
	"hanya",
	"membuat",
	"dapat",
	"lihat",
	"begini",
	"kalau",
	"karena",
	"memang",
	"zaman",
	"izin",
	"risiko",
	"aktivitas",
	"kualitas",
	"analisis",
	"praktik",
	"nasihat",
	"sekadar",
	"silakan",
	"mengubah",
	"menyukseskan",
	"imbauan",
	"diimbau",
	"nonaktif",
	"asyik"
]

const unbaku_list = [
	"rame",
	"seneng",
	"banget",
	"capek",
	"bilang",
	"kayak",
	"nggak",
	"futuristik",
	"udah",
	"cuma",
	"bikin",
	"dapet",
	"liat",
	"gini",
	"kalo",
	"karna",
	"emang",
	"jaman",
	"ijin",
	"resiko",
	"aktifitas",
	"kwalitas",
	"analisa",
	"praktek",
	"nasehat",
	"sekedar",
	"silahkan",
	"merubah",
	"mensukseskan",
	"himbauan",
	"dihimbau",
	"non-aktif",
	"asik"
]

var words: Array = []
var clicked: Array = []
var rightAnswer: Array = []

var text_berita: String = ""
var judul_berita: String = ""

const berita_file = "res://berita.txt"
var berita_list: Array = []


func _on_word_clicked(meta: Variant) -> void:
	var clicked_word = str(meta)
	
	print("You clicked the word: ", clicked_word)

	if clicked_word not in clicked:
		if clicked.size() < 6:
			clicked.append(clicked_word)
			mengarsir_text.play()
		else:
			print("warning and give pop up")
	else:
		clicked.erase(clicked_word)

	print(clicked)

	_print()


func load_paragraphs() -> void:
	if not FileAccess.file_exists(berita_file):
		print("Error: Paragraph file not found!")
		return

	var file = FileAccess.open(berita_file, FileAccess.READ)
	var full_text = file.get_as_text()
	file.close()

	berita_list = full_text.split("---")

	for i in range(berita_list.size()):
		berita_list[i] = berita_list[i].strip_edges()


func display_random_paragraph() -> void:
	var word_list: Array = []

	if berita_list.is_empty():
		text = "No Paragraphs Loaded."
		Judul.text = "No Judul Loaded"
		return

	# Reset pilihan kalau ganti berita
	clicked.clear()

	var random_word = 0
	var i = 0

	while i <= 32:
		random_word = randi_range(1, 4)

		if random_word == 1:
			word_list.append(baku_list[i])
		else:
			word_list.append(unbaku_list[i])

		i += 1

	var random_index = (randi_range(1, 50) * 2) - 1
	var raw_text = berita_list[random_index]

	var data = {
		"rame": word_list[0],
		"seneng": word_list[1],
		"banget": word_list[2],
		"capek": word_list[3],
		"bilang": word_list[4],
		"kayak": word_list[5],
		"nggak": word_list[6],
		"futuristik": word_list[7],
		"udah": word_list[8],
		"cuma": word_list[9],
		"bikin": word_list[10],
		"dapet": word_list[11],
		"liat": word_list[12],
		"gini": word_list[13],
		"kalo": word_list[14],
		"karna": word_list[15],
		"emang": word_list[16],
		"jaman": word_list[17],
		"ijin": word_list[18],
		"resiko": word_list[19],
		"aktifitas": word_list[20],
		"kwalitas": word_list[21],
		"analisa": word_list[22],
		"praktek": word_list[23],
		"nasehat": word_list[24],
		"sekedar": word_list[25],
		"silahkan": word_list[26],
		"merubah": word_list[27],
		"mensukseskan": word_list[28],
		"himbauan": word_list[29],
		"dihimbau": word_list[30],
		"non-aktif": word_list[31],
		"asik": word_list[32]
	}

	text_berita = raw_text.format(data)
	judul_berita = berita_list[random_index - 1]

	_print()


func _ready() -> void:
	load_paragraphs()

	# Connect cukup sekali saja
	if !meta_clicked.is_connected(_on_word_clicked):
		meta_clicked.connect(_on_word_clicked)

	display_random_paragraph()


func _print() -> void:
	bbcode_enabled = true

	words = text_berita.split(" ")

	var bbcode_result: PackedStringArray = PackedStringArray()

	for word in words:
		var clean_word = word.replace(".", "")

		var wrapped_word = ""

		# Kalau kata sudah dipilih → kasih highlight
		if clean_word in clicked:
			wrapped_word = ("[url=" + clean_word + "]" + "[bgcolor=#FFD54F]" + word + "[/bgcolor]" + "[/url]")
		# Kalau belum dipilih → normal
		else:
			wrapped_word = ("[url=" + clean_word + "]" + word + "[/url]")

		bbcode_result.append(wrapped_word)

	text = " ".join(bbcode_result)
	Judul.text = judul_berita

func bantuan_kopi() -> bool:
	var kandidat: Array = []

	for word in words:
		var clean_word = word.replace(".", "")

		if clean_word in unbaku_list and clean_word not in clicked:
			kandidat.append(clean_word)

	if kandidat.is_empty():
		return false

	if clicked.size() >= 6:
		return false
		
	mengarsir_text.play()
	var pilihan = kandidat.pick_random()

	clicked.append(pilihan)
	await grid_container._on_paragraph_meta_clicked(null)

	_print()

	return true
