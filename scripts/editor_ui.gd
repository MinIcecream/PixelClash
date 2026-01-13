extends BaseUI
signal save_battle
@onready var save_button = $"Control/SaveButton"

func _connect_signals() -> void:
	save_button.pressed.connect(Callable(self, "_on_save_button_pressed"))

func _on_save_button_pressed() -> void:
	emit_signal("save_battle")
