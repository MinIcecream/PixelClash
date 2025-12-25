@tool
class_name BattleContext
extends Node

@export var battle_data: BattleData

func get_grid_width() -> int:
	return battle_data.player_grid_width

func get_grid_height() -> int:
	return battle_data.player_grid_height

func get_starting_gold() -> int:
	return battle_data.player_starting_gold
