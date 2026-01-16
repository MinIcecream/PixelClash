extends UITool

var unit: UnitData

func press():
	input_manager.set_mode(input_manager.InteractionModeType.PLACE, unit)

func set_unit(unit_data: UnitData) -> void:
	unit = unit_data
	button.texture_normal = unit.sprite
