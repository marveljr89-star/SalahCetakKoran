extends Sprite2D

var posisi = position
var geser = 0

var outline_tweens: Dictionary = {}
var float_tweens: Dictionary = {}
var original_y: Dictionary = {}
var original_x: Dictionary = {}

@onready var hover_audio: AudioStreamPlayer2D = $HoverAudio
@onready var tunjukan_hasil: Node2D = $"../TunjukanHasil"

func _process(delta: float) -> void:
	geser = get_global_mouse_position() * 4 * delta
	position = posisi - geser

func _ready() -> void:
	for child in get_children():
		if child is Sprite2D:
			var area = child.get_node_or_null("Area2D")

			original_y[child] = child.position.y
			original_x[child] = child.position.x

			if !child.has_meta("AnimatedDone"):
				child.set_meta("AnimatedDone", true)
			if !child.has_meta("AnimFloatHold"):
				child.set_meta("AnimFloatHold", false)

			child.visibility_changed.connect(
				func():
					_on_child_visibility_changed(child, area)
			)

			if area:
				var thic = child.get_meta("Outline", 0.0)
				area.mouse_entered.connect(
					func():
						_on_object_mouse_entered(child, thic)
				)
				area.mouse_exited.connect(
					func():
						_on_object_mouse_exited(child)
				)


func _on_object_mouse_entered(sprite: Sprite2D, thic: float) -> void:
	var mat = sprite.material as ShaderMaterial

	if mat and sprite.get_meta("AnimFloatHold", false) == false and tunjukan_hasil.visible == false:
		_animate_outline(sprite, mat, thic)
		hover_audio.play()
		_animate_float(sprite, original_y[sprite] - 10.0, original_x[sprite], .2)

func _on_object_mouse_exited(sprite: Sprite2D) -> void:
	var mat = sprite.material as ShaderMaterial

	if mat and sprite.get_meta("AnimFloatHold", false) == false and tunjukan_hasil.visible == false:
		sprite.set_meta("AnimatedDone", false)
		_animate_outline(sprite, mat, 0.0)
		await _animate_float(
			sprite,
			original_y[sprite],
			original_x[sprite],
			.2
		)
		sprite.set_meta("AnimatedDone", true)

func _animate_outline(sprite: Sprite2D, mat: ShaderMaterial, target_thickness: float) -> void:
	if outline_tweens.has(sprite):
		var old_tween: Tween = outline_tweens[sprite]
		if old_tween:
			old_tween.kill()
			
	var current_thickness = float(mat.get_shader_parameter("thickness"))
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value: float):
			mat.set_shader_parameter("thickness", value),
		current_thickness,
		target_thickness,
		0.2
	)
	
	
	
	outline_tweens[sprite] = tween

func _animate_float(sprite: Sprite2D, target_y: float, target_x: float, time: float) -> void:
	if float_tweens.has(sprite):
		var old_tween: Tween = float_tweens[sprite]
		if old_tween:
			old_tween.kill()

	var current_y = sprite.position.y
	var current_x = sprite.position.x
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value: float):
			sprite.position.y = value,
		current_y,
		target_y,
		time
	)
	tween.parallel().tween_method(
		func(value: float):
			sprite.position.x = value,
		current_x,
		target_x,
		time
	)
	
	float_tweens[sprite] = tween
	await tween.finished

func reActive(sprite: Sprite2D) -> void:
	_animate_float(sprite, original_y[sprite], original_x[sprite], 0.2)

func stop_float(sprite: Sprite2D) -> void:
	if float_tweens.has(sprite):
		var tween: Tween = float_tweens[sprite]
		if tween:
			tween.kill()
		float_tweens.erase(sprite)

func stop_outline(sprite: Sprite2D) -> void:
	sprite.material.set_shader_parameter("thickness", 0)

func _on_child_visibility_changed(sprite: Sprite2D, area: Area2D) -> void:
	if sprite.visible:
		if area:
			area.input_pickable = false
		await _animate_child_appear(sprite)
		if area:
			area.input_pickable = true

func _animate_child_appear(sprite: Sprite2D) -> void:
	sprite.set_meta("AnimatedDone", false)

	var target_y = original_y[sprite]
	var target_x = original_x[sprite]

	sprite.position.y = target_y - 50.0
	sprite.position.x = target_x
	
	await _animate_float(
		sprite,
		target_y,
		target_x,
		.5
	)

	sprite.set_meta("AnimatedDone", true)
