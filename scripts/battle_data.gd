@tool
class_name BattleData
extends Resource

@export var id: String
@export var display_name: String
@export var grid_width: int = 30
@export var grid_height: int = 15
@export var player_grid: Rect2i

@export var player_starting_gold: int = 100

@export var enemy_units: Dictionary[Vector2i, UnitData] = {}

func add_unit(cell: Vector2i, unit: UnitData) -> void:
	print("Hi")
	enemy_units[cell] = unit

func remove_unit(cell: Vector2i) -> void:
	if cell in enemy_units:
		enemy_units.erase(cell)
