@tool
class_name Grid
extends Node

signal place_unit(position: Vector2, unit: PackedScene)

@export var cell_size: int = 16
var width: int
var height: int
@export var battle_context: BattleContext
@onready var input_manager = $"../InputManager"
@onready var gold_manager = $"../GoldManager"

var cells = {} #Vector2: unit

func _ready() -> void:
	width = battle_context.get_player_grid().size.x
	height = battle_context.get_player_grid().size.y
	input_manager.connect("place_unit", Callable(self, "_on_place_unit"))

func world_to_cell(pos: Vector2) -> Vector2i:
	var x = int(floor(pos.x / cell_size))
	var y = int(floor(pos.y / cell_size))
	return Vector2i(x, y)
	
func cell_to_world(cell: Vector2i) -> Vector2:
	return (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size

func _on_place_unit(start: Vector2, stop: Vector2, unit: UnitData) -> void:
	var selected_cells = get_cells_in_rect(start, stop)
	var gold = unit.price * get_unoccupied_cells_in_rect(start, stop).size()
	if gold > gold_manager.gold:
		print("Not enough gold!")
		return
	gold_manager.spend_gold(gold)
	for cell in selected_cells:
		var cell_center = cell_to_world(Vector2i(cell.x, cell.y))
		if cell in cells:
			print("Cell already occupied!")
			continue

		place_unit.emit(cell_center, unit)
		var instance = UnitRegistry.units[unit.name].scene.instantiate()
		instance.global_position = cell_center
		add_child(instance)
		cells[cell] = instance

func out_of_bounds_selection(left, right, top, bottom) -> bool:
	var player_grid = battle_context.get_player_grid()
	var left_bound = player_grid.position.x
	var right_bound = player_grid.end.x
	var top_bound = player_grid.position.y
	var bottom_bound = player_grid.end.y
	if left < left_bound and right < left_bound:
		return true
	if right >= right_bound and left >= right_bound:
		return true
	if top < top_bound and bottom < top_bound:
		return true
	if top >= bottom_bound and bottom >= bottom_bound:
		return true
	return false

func get_cell_bounds(cell: Vector2i) -> Rect2i:
	var world_pos = Vector2(cell) * cell_size
	return Rect2(world_pos, Vector2i(cell_size, cell_size))

func get_cells_in_rect(start: Vector2, stop: Vector2) -> Array[Vector2]:
	var cell1 = world_to_cell(start)
	var cell2 = world_to_cell(stop)

	var left = min(cell1.x, cell2.x)
	var right = max(cell1.x, cell2.x)
	var top = min(cell1.y, cell2.y)
	var bottom = max(cell1.y, cell2.y)
	var output: Array[Vector2] = []

	if out_of_bounds_selection(left, right, top, bottom):
		return output
	
	var player_grid = battle_context.get_player_grid()
	var left_bound = player_grid.position.x
	var right_bound = player_grid.end.x
	var top_bound = player_grid.position.y
	var bottom_bound = player_grid.end.y
	var clamped_left = clamp(left, left_bound, right_bound)
	var clamped_right = clamp(right, left_bound, right_bound)
	var clamped_top = clamp(top, top_bound, bottom_bound)
	var clamped_bottom = clamp(bottom, top_bound, bottom_bound)
	
	for x in range(clamped_left, clamped_right + 1):
		for y in range(clamped_top, clamped_bottom + 1):
			output.append(Vector2(x, y))

	return output

func get_unoccupied_cells_in_rect(start: Vector2, stop: Vector2) -> Array[Vector2]:
	var selected_cells = get_cells_in_rect(start, stop)
	var output: Array[Vector2] = []
	for cell in selected_cells:
		if cell not in cells:
			output.append(cell)
	return output
