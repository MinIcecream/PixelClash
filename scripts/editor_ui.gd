extends BaseUI
signal save_battle

@onready var save_button = $"Control/SaveButton"
@onready var toolbar = $"Control/HBoxContainer"

func _connect_signals() -> void:
	save_button.pressed.connect(Callable(self, "_on_save_button_pressed"))

func _on_save_button_pressed() -> void:
	emit_signal("save_battle")

func _setup_ui() -> void:
	for unit in UnitRegistry.units:
		var instance = unit_selector_panel.instantiate()
		toolbar.add_child(instance)
		instance.set_unit(UnitRegistry.units[unit].data)
