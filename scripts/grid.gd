extends Node2D

signal place_unit(position: Vector2, unit: PackedScene)

@export var cell_size: int = 16
@export var width: int = 20
@export var height: int = 20
@export var top_left = Vector2(-240, -240)

@onready var input_manager = $"../InputManager"

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

func _on_place_unit(start: Vector2, stop: Vector2, unit: PackedScene) -> void:
	var cell1 = world_to_cell(start)
	var cell2 = world_to_cell(stop)

	var left = clamp(min(cell1.x, cell2.x), 0, width - 1)
	var right = clamp(max(cell1.x, cell2.x), 0, width - 1)
	var top = clamp(min(cell1.y, cell2.y), 0, height - 1)
	var bottom = clamp(max(cell1.y, cell2.y), 0, height - 1)

	for x in range(left, right + 1):
		for y in range(top, bottom + 1):
			if out_of_bounds(Vector2i(x, y)):
				print("Out of bounds!")
				continue

			var cell_center = cell_to_world(Vector2i(x, y))
			if cell_center in cells:
				print("Cell already occupied!")
				continue

			place_unit.emit(cell_center, unit)
			var instance = unit.instantiate()
			instance.global_position = cell_center
			add_child(instance)
			cells[cell_center] = instance
	
func out_of_bounds(cell: Vector2i) -> bool:
	if cell.x < 0 or cell.x > width - 1:
		return true
	if cell.y < 0 or cell.y > height - 1:
		return true
	return false
