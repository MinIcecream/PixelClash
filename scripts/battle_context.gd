@tool
class_name BattleContext
extends Node

var battle_data: BattleData

func get_grid_width() -> int:
	return battle_data.grid_width

func get_grid_height() -> int:
	return battle_data.grid_height
	
func get_starting_gold() -> int:
	return battle_data.player_starting_gold

func get_enemy_units() -> Dictionary:
	return battle_data.enemy_units
	
func get_player_grid() -> Rect2i:
	return battle_data.player_grid
