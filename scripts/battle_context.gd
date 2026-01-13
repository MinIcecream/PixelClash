@tool
class_name BattleContext
extends Node

var battle_data: BattleData
@onready var grid = $"../Grid"
	
func get_starting_gold() -> int:
	return battle_data.player_starting_gold

func get_enemy_units() -> Dictionary:
	return battle_data.enemy_units

func _ready() -> void:
	grid.set_grid(battle_data.player_grid, battle_data.outer_grid)
	
func set_battle_data(_battle_data: BattleData) -> void:
	battle_data = _battle_data
