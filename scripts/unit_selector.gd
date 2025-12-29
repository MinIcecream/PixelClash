extends UITool

@export var unit: UnitData

func press():
	input_manager.set_mode(input_manager.InteractionModeType.PLACE, unit)
