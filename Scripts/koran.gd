extends Node2D

@onready var paragraph: RichTextLabel = $KoranUI/Paragraph
@onready var TextSlot1: Panel = $Sheet/GridContainer/TextSlot1
@onready var TextSlot2: Panel = $Sheet/GridContainer/TextSlot2
@onready var TextSlot3: Panel = $Sheet/GridContainer/TextSlot3
@onready var TextSlot4: Panel = $Sheet/GridContainer/TextSlot4
@onready var TextSlot5: Panel = $Sheet/GridContainer/TextSlot5
@onready var TextSlot6: Panel = $Sheet/GridContainer/TextSlot6
@onready var audio_koran: AudioStreamPlayer2D = $AudioKoran

var koran_atas_meja: Sprite2D

@onready var tutup = find_child("Tutup") as Sprite2D

var Koran_Anim: Dictionary = {}

func _TutupKoranTween(sprite: Node2D) -> void:
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
		current_x,
		current_x + 500,
		0.2
	)
	
	Koran_Anim[sprite] = tween
	await tween.finished

func _on_texture_button_button_down_TutupKoran() -> void:
	audio_koran.play()
	if !is_instance_valid(koran_atas_meja):
		return
	if get_meta("AnimatedDone", true) and koran_atas_meja.get_meta("AnimatedDone", true):
		set_meta("AnimatedDone", false)
		await _TutupKoranTween(self)
		visible = false
		position.x -= 500
		koran_atas_meja.set_meta("KoranOpen", false)
		set_meta("AnimatedDone", true)
