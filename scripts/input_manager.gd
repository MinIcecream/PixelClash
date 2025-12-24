extends Node2D

signal place_unit(position: Vector2, unit: UnitData)
signal drag_release

var start = null
var selected_unit: UnitData = null

@onready var game_manager = $"../GameManager"
@onready var gold_manager = $"../GoldManager"
@onready var UI = $"../UI"
@onready var grid = $"../Grid"
@onready var grid_drawer = $"../Grid/Drawer"
@onready var grid_selection_overlay = $"../Grid/GridSelectionOverlay"

func _ready() -> void:
	UI.select_unit.connect(Callable(self, "_on_select_unit"))

func _unhandled_input(event):
	if game_manager.game_started:
		return

	var stop = get_global_mouse_position()

	if event is InputEventMouseMotion:
		if start == null:
			return
		var cells = grid.get_unoccupied_cells_in_rect(start, stop)
		if selected_unit != null:
			var cost = gold_manager.gold - (cells.size() * selected_unit.price)
			grid_selection_overlay.set_preview_gold(cost)
			UI.set_preview_gold(cost)
		grid_selection_overlay.set_selection([start, stop])

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start = stop
			grid_selection_overlay.set_selection([start, start])
		else:
			if start == null:
				return
			emit_signal("drag_release")
			grid_selection_overlay.set_selection([])
			spawn_at_mouse(start, stop)
			start = null


func spawn_at_mouse(first_pos, second_pos):
	if selected_unit == null:
		print("no unit selected!")
		return
	emit_signal("place_unit", first_pos, second_pos, selected_unit)

func _on_select_unit(unit: UnitData):
	selected_unit = unit
