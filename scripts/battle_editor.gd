@tool
extends Node

var battle_data: BattleData

@export var grid: Grid
@export var selected_unit: UnitData
@export var enabled = false
@onready var ui = $"../UI"

func _ready() -> void:
	grid.set_grid(battle_data.outer_grid, battle_data.outer_grid)
	ui.save_battle.connect(Callable(self, "_save_game"))

func get_enemy_units() -> Dictionary:
	return battle_data.enemy_units

func set_battle_data(data: BattleData):
	battle_data = data

func _save_game():
	var enemy_units: Dictionary[Vector2i, UnitData] = {}
	var units_set: Dictionary[CharacterBody2D, Vector2i] = {} # because in grid.used_cells, each unit appears multiple times(each cell they occupy)
	for cell in grid.used_cells:
		var unit = grid.used_cells[cell]
		units_set[unit] = unit.origin
	
	for unit in units_set:
		enemy_units[units_set[unit]] = unit.data
	battle_data.enemy_units = enemy_units
	ResourceSaver.save(battle_data, battle_data.resource_path)
