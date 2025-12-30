extends Node

var units: Dictionary[String, bool] = {
	"swordsman": true,
	"archer": true
}

func get_unlocked_units() -> Array[String]:
	var unlocked_units: Array[String] = []
	for unit in units:
		if units[unit] == true:
			unlocked_units.append(unit)
	return unlocked_units

func unlock_unit(name: String):
	units[name] = true
