extends Node2D

@onready var results: NinePatchRect = $Results
@onready var cekHasil: Node2D = $CekHasil
@onready var OriResulty: int = results.position.y
@onready var OriHasily: int = cekHasil.position.y
@onready var hover_audio: AudioStreamPlayer2D = $CekHasil/HoverAudio

var slideTween: Dictionary = {}

func _SlideTween(sprite, current_y: int, Targety: int) -> void:
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
		0.2
	)
	
	slideTween[sprite] = tween
	await tween.finished

func _on_texture_button_pressed_cekHasil() -> void:
	if cekHasil.visible:
		if cekHasil.get_meta("AnimatedDone", true):
			hover_audio.play()
			results.set_meta("AnimatedDone", false)
			cekHasil.set_meta("AnimatedDone", false)
			results.visible = true
			await _SlideTween(cekHasil, OriHasily + 700, OriHasily)
			await _SlideTween(results, OriResulty + 750, OriResulty)
			cekHasil.visible = false
			results.set_meta("AnimatedDone", true)
			cekHasil.set_meta("AnimatedDone", true)

func _on_texture_button_pressed_results() -> void:
	if results.visible:
		if results.get_meta("AnimatedDone", true):
			hover_audio.play()
			results.set_meta("AnimatedDone", false)
			cekHasil.set_meta("AnimatedDone", false)
			cekHasil.visible = true
			await _SlideTween(results, OriResulty, OriResulty + 750)
			await _SlideTween(cekHasil, OriHasily, OriHasily + 700)
			results.visible = false
			results.set_meta("AnimatedDone", true)
			cekHasil.set_meta("AnimatedDone", true)
