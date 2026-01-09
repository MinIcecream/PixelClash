extends InteractionMode

class_name EraseUnitMode

signal preview_gold(gold)
signal clear_preview_gold()

var gold_manager
var grid
var game_manager

func on_press(cell: Array[Vector2i]) -> void:
	var units_to_delete = grid.get_units_in_cells(cell)
	var gold_refunded = 0
	for unit in units_to_delete:
		gold_refunded += unit.data.price
	emit_signal("preview_gold", gold_refunded)

func on_drag(cells: Array[Vector2i]) -> void:
	var units_to_delete = grid.get_units_in_cells(cells)
	var gold_refunded = 0
	for unit in units_to_delete:
		gold_refunded += unit.data.price
	emit_signal("preview_gold", gold_refunded)

func on_release(cells: Array[Vector2i]) -> void:
	var units_to_delete = grid.get_units_in_cells(cells)
	for unit in units_to_delete:
		game_manager.delete_unit(unit)
	emit_signal("clear_preview_gold")
