extends Node

@onready var conf: esc_pause_button = $PauseButton
@onready var sumbit_koran: ConfirmationKoran = $SumbitKoran

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			if sumbit_koran.get_meta("Active"):
				conf._tutup_confirmasi_koran(false)
			else:
				conf._tutup_confirmasi_koran(true)
		else:
			conf._checkPause(true)
