@tool
class_name Grid
extends Node

signal place_unit(position: Vector2, unit: PackedScene)

@export var cell_size: int = 16
@export var width: int = 30
@export var height: int = 15

@onready var input_manager = $"../InputManager"
@onready var gold_manager = $"../GoldManager"

var top_left = Vector2(-width * cell_size / 2.0, -height * cell_size / 2.0)

var cells = {} #Vector2: unit

func _ready() -> void:
	input_manager.connect("place_unit", Callable(self, "_on_place_unit"))

func world_to_cell(pos: Vector2) -> Vector2i:
	var local = pos - top_left

	var x = int(floor(local.x / cell_size))
	var y = int(floor(local.y / cell_size))
	return Vector2i(x, y)
	
func cell_to_world(cell: Vector2i) -> Vector2:
	return top_left + (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size

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
	if left < 0 and right < 0:
		return true
	if right >= width and left >= width:
		return true
	if top < 0 and bottom < 0:
		return true
	if top >= height and bottom >= height:
		return true
	return false

func get_cell_bounds(cell: Vector2i) -> Rect2i:
	var world_pos = top_left + Vector2(cell) * cell_size
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

	var clamped_left = clamp(left, 0, width - 1)
	var clamped_right = clamp(right, 0, width - 1)
	var clamped_top = clamp(top, 0, height - 1)
	var clamped_bottom = clamp(bottom, 0, height - 1)
	
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
