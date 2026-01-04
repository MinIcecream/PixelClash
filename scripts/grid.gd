@tool
class_name Grid
extends Node

@export var cell_size: int = 16
var width: int
var height: int
var player_grid: Rect2i
@export var battle_context: BattleContext

var used_cells: Dictionary[Vector2i, CharacterBody2D]

func set_grid(player_grid: Rect2i, entire_grid: Vector2i) -> void:
	self.player_grid = player_grid
	width = entire_grid.x
	height = entire_grid.y

func world_to_cell(pos: Vector2) -> Vector2i:
	var x = int(floor(pos.x / cell_size))
	var y = int(floor(pos.y / cell_size))
	return Vector2i(x, y)
	
# func cell_to_world(cell: Vector2i) -> Vector2:
# 	return (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size

func world_pos_to_spawn_unit(origin: Vector2i, unit: UnitData) -> Vector2:
	var center_x = origin.x + unit.size.x / 2.0
	var center_y = origin.y + unit.size.y / 2.0
	
	return Vector2(center_x, center_y) * cell_size
	

func place_unit(cell: Vector2i, unit: UnitData) -> void:
	var cell_center = world_pos_to_spawn_unit(Vector2i(cell.x, cell.y), unit)
	if cell in used_cells:
		return

	var instance = UnitRegistry.units[unit.name].scene.instantiate()
	instance.global_position = cell_center
	instance.origin = cell
	self.add_child(instance)
	for unit_cell in get_cells_for_unit(cell, unit):
		used_cells[unit_cell] = instance

func out_of_bounds_cell(cell: Vector2i) -> bool:
	var left_bound = player_grid.position.x
	var right_bound = player_grid.end.x
	var top_bound = player_grid.position.y
	var bottom_bound = player_grid.end.y
	if cell.x < left_bound:
		return true
	if cell.x >= right_bound:
		return true
	if cell.y < top_bound:
		return true
	if cell.y >= bottom_bound:
		return true
	return false

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

# Get a list of possible origins of units given cells
func get_unit_origins(cells: Array[Vector2i], unit: UnitData) -> Array[Vector2i]:
	var potential_cells = {}
	var output: Array[Vector2i] = []
	for cell in cells:
		if cell in used_cells:
			continue
		var invalid_origin = false
		var cells_to_consider = get_cells_for_unit(cell, unit)
		for cell_to_consider in cells_to_consider:
			if out_of_bounds_cell(cell_to_consider) or cell_to_consider in potential_cells or cell_to_consider in used_cells:
				invalid_origin = true
				break
		if invalid_origin:
			continue
		for c in cells_to_consider:
			potential_cells[c] = true
		output.append(cell)
	return output

func get_units_in_cells(cells: Array[Vector2i]) -> Array[CharacterBody2D]:
	var found_units = {}
	for cell in cells:
		if cell in used_cells:
			var unit = used_cells[cell]
			found_units[unit] = true
	var output: Array[CharacterBody2D] = []
	for unit in found_units.keys():
		output.append(unit)
	return output

func delete_unit(unit: CharacterBody2D):
	var origin = unit.origin
	for cell in get_cells_for_unit(origin, unit.data):
		used_cells.erase(cell)
	unit.queue_free()

func get_cells_for_unit(origin: Vector2i, unit_data: UnitData) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(unit_data.size.x):
		for y in range(unit_data.size.y):
			cells.append(origin + Vector2i(x, y))

	return cells
