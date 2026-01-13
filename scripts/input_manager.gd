@tool
extends Node2D
class_name InputManager
signal select_cells(cells: Array[Vector2i])
signal preview_gold(gold)
signal clear_preview_gold()

enum InteractionModeType {
	SELECT,
	PLACE,
	ERASE
}

var start = null
var selected_unit: UnitData = null
var current_interaction: InteractionMode

@onready var game_manager = $"../GameManager"
@onready var UI = $"../UI"
@onready var grid = $"../Grid"
@onready var gold_manager = $"../GoldManager"
@onready var grid_selection_overlay = $"../Grid/GridSelectionOverlay"

func set_mode(mode_type: InteractionModeType, payload: Variant = null):
	match mode_type:
		InteractionModeType.PLACE:
			current_interaction = PlaceUnitMode.new(payload)
			current_interaction.grid = grid
			current_interaction.gold_manager = gold_manager
			current_interaction.preview_gold.connect(Callable(self, "_on_preview_gold"))
			current_interaction.clear_preview_gold.connect(Callable(self, "_on_clear_preview_gold"))
		InteractionModeType.ERASE:
			current_interaction = EraseUnitMode.new()
			current_interaction.grid = grid
			current_interaction.gold_manager = gold_manager
			current_interaction.game_manager = game_manager
			current_interaction.preview_gold.connect(Callable(self, "_on_preview_gold"))
			current_interaction.clear_preview_gold.connect(Callable(self, "_on_clear_preview_gold"))
		InteractionModeType.SELECT:
			current_interaction = SelectMode.new()

func _unhandled_input(event):
	if game_manager.game_started or not current_interaction:
		return

	var stop = get_global_mouse_position()

	if event is InputEventMouseMotion:
		if start == null:
			return
		var cells = grid.get_cells_in_rect(start, stop)
		current_interaction.on_drag(cells)
		emit_signal("select_cells", [start, stop])

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start = stop
			var cells = grid.get_cells_in_rect(start, stop)
			current_interaction.on_press(cells)
			emit_signal("select_cells", [start, stop])
		else:
			if start == null:
				return
			var cells = grid.get_cells_in_rect(start, stop)
			current_interaction.on_release(cells)
			emit_signal("select_cells", [])
			start = null

func _on_preview_gold(gold: int):
	emit_signal("preview_gold", gold)

func _on_clear_preview_gold():
	emit_signal("clear_preview_gold")
