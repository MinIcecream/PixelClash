extends Node

var units: Dictionary[String, bool] = {
	"swordsman": true,
	"archer": true,
	"knight": true,
	"calvalry": true,
	"alchemist": true
}

var battles: Dictionary[String, bool] = {
	"battle_01": true,
	"battle_02": true
}

func get_unlocked_units() -> Array[String]:
	var unlocked_units: Array[String] = []
	for unit in units:
		if units[unit] == true:
			unlocked_units.append(unit)
	return unlocked_units

func unlock_unit(name: String):
	units[name] = true

func get_unlocked_battles() -> Array[String]:
	return battles.keys()

func unlock_battle(battle_id: String):
	battles[battle_id] = true
