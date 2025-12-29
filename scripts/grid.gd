@tool
class_name Grid
extends Node

@export var cell_size: int = 16
var width: int
var height: int
var player_grid: Rect2i
@export var battle_context: BattleContext

var used_cells = {} #Vector2: unit

func _ready() -> void:
	player_grid = battle_context.get_player_grid()
	width = battle_context.get_grid_width()
	height = battle_context.get_grid_height()

func world_to_cell(pos: Vector2) -> Vector2i:
	var x = int(floor(pos.x / cell_size))
	var y = int(floor(pos.y / cell_size))
	return Vector2i(x, y)
	
func cell_to_world(cell: Vector2i) -> Vector2:
	return (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size

func place_unit(cell: Vector2i, unit: UnitData) -> void:
	var cell_center = cell_to_world(Vector2i(cell.x, cell.y))
	if cell in used_cells:
		print("Cell already occupied!")
		return

	var instance = UnitRegistry.units[unit.name].scene.instantiate()
	instance.global_position = cell_center
	self.add_child(instance)
	used_cells[cell] = instance

func out_of_bounds_selection(left, right, top, bottom) -> bool:
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

func get_cells_in_rect(start: Vector2, stop: Vector2) -> Array[Vector2i]:
	var cell1 = world_to_cell(start)
	var cell2 = world_to_cell(stop)

	var left = min(cell1.x, cell2.x)
	var right = max(cell1.x, cell2.x)
	var top = min(cell1.y, cell2.y)
	var bottom = max(cell1.y, cell2.y)
	var output: Array[Vector2i] = []

	if out_of_bounds_selection(left, right, top, bottom):
		return output
	
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
			output.append(Vector2i(x, y))

	return output

func get_unit_origins(cells: Array[Vector2i], unit: UnitData) -> Array[Vector2i]:
	var output: Array[Vector2i] = []
	for cell in cells:
		if cell not in used_cells:
			output.append(cell)
	return output
