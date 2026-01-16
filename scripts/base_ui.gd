extends CanvasLayer
class_name BaseUI

signal back_to_main

@onready var back_button = $"Control/BackButton"
@export var unit_selector_panel: PackedScene

func _ready() -> void:
	back_button.pressed.connect(Callable(self, "_on_back_button_pressed"))
	_connect_signals()
	_setup_ui()

func _connect_signals() -> void:
	pass

func _setup_ui() -> void:
	pass

func on_select_tool(selected_panel: PanelContainer) -> void:
	for panel in get_tree().get_nodes_in_group("ui_tool"):
		if panel != selected_panel:
			panel.deselect()
	selected_panel.select()

func _on_back_button_pressed() -> void:
	emit_signal("back_to_main")
