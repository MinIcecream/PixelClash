extends Node

var units: Dictionary[String, bool] = {
	"swordsman": true,
	"archer": false,
	"knight": true,
	"calvalry": true,
	"alchemist": true
}

var battles: Dictionary[String, bool] = {
	"battle_01": true,
	"battle_02": false
}

var unlock: Dictionary[String, Dictionary] = {
	"battle_01": {
		"battles": ["battle_02"],
		"units": ["archer"]
	}
}

func unlock_after_battle(battle_id: String) -> void:
	for battle in unlock[battle_id]["battles"]:
		unlock_battle(battle)
	for unit in unlock[battle_id]["units"]:
		unlock_unit(unit)

func get_unlocked_units() -> Array[String]:
	var unlocked_units: Array[String] = []
	for unit in units:
		if units[unit] == true:
			unlocked_units.append(unit)
	return unlocked_units

func unlock_unit(unit_name: String):
	units[unit_name] = true

func get_unlocked_battles() -> Array[String]:
	var unlocked_battles: Array[String] = []
	for battle in battles:
		if battles[battle] == true:
			unlocked_battles.append(battle)
	return unlocked_battles

func unlock_battle(battle_id: String):
	battles[battle_id] = true
