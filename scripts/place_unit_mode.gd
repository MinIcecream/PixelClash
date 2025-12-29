extends InteractionMode

class_name PlaceUnitMode

signal preview_gold(gold)
signal clear_preview_gold()

var selected_unit: UnitData
var gold_manager
var grid

func _init(unit_data):
	self.selected_unit = unit_data

func on_press(cell: Array[Vector2i]) -> void:
	var unit_origins = grid.get_unit_origins(cell, selected_unit)
	var total_cost = UnitRegistry.units[selected_unit.name].data.price * unit_origins.size()

	emit_signal("preview_gold", gold_manager.gold - total_cost)

func on_drag(cells: Array[Vector2i]) -> void:
	var unit_origins = grid.get_unit_origins(cells, selected_unit)
	var total_cost = UnitRegistry.units[selected_unit.name].data.price * unit_origins.size()

	emit_signal("preview_gold", gold_manager.gold - total_cost)

func on_release(cells: Array[Vector2i]) -> void:
	emit_signal("clear_preview_gold")
	var unit_origins = grid.get_unit_origins(cells, selected_unit)
	var total_cost = UnitRegistry.units[selected_unit.name].data.price * unit_origins.size()
	if total_cost <= gold_manager.gold:
		gold_manager.spend_gold(total_cost)
		for cell in unit_origins:
			grid.place_unit(cell, selected_unit)
