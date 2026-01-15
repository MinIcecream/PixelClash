extends CanvasLayer
class_name BaseUI

signal back_to_main

@onready var back_button = $"Control/BackButton"

func _ready() -> void:
	back_button.pressed.connect(Callable(self, "_on_back_button_pressed"))
	_connect_signals()
	_setup_ui()

func _connect_signals() -> void:
	pass

func _setup_ui() -> void:
	pass

func on_select_tool(selected_button: TextureButton) -> void:
	for button in get_tree().get_nodes_in_group("ui_tool"):
		if button != selected_button:
			button.lighten()
	selected_button.darken()

func _on_back_button_pressed() -> void:
	emit_signal("back_to_main")
