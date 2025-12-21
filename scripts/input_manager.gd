extends Node2D

signal place_unit(position: Vector2, unit: UnitData)
var start = null
var selected_unit: UnitData = null

@onready var game_manager = $"../GameManager"
@onready var UI = $"../UI"

func _ready() -> void:
	UI.select_unit.connect(Callable(self, "_on_select_unit"))

func _unhandled_input(event):
	if game_manager.game_started:
		return
	if selected_unit == null:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start = get_global_mouse_position()
		else:
			if start == null:
				return
			var stop = get_global_mouse_position()
			spawn_at_mouse(start, stop)
			start = null

func spawn_at_mouse(first_click, second_click):
	emit_signal("place_unit", first_click, second_click, selected_unit)

func _on_select_unit(unit: UnitData):
	selected_unit = unit
