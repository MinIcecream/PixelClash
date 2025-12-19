extends Node2D

@export var grid_size: int = 24
@export var width: int = 1024
@export var height: int = 1024
@export var center = Vector2.ZERO

@onready var input_manager = $"../InputManager"

var cells = {} #Vector2: unit
var top_left: Vector2:
	get:
		return center - Vector2(width, height) / 2
var bottom_right: Vector2:
	get:
		return center + Vector2(width, height) / 2

func _ready() -> void:
	input_manager.connect("place_unit", Callable(self, "_on_place_unit"))

func vector2_to_cell(pos: Vector2) -> Vector2:
	# Compute relative position to top-left
	var rel_pos = pos - top_left
	
	# Find the nearest cell index
	var cell_x = int(rel_pos.x / grid_size + 0.5)
	var cell_y = int(rel_pos.y / grid_size + 0.5)
	
	# Clamp to grid bounds (optional)
	cell_x = clamp(cell_x, 0, int(width / grid_size) - 1)
	cell_y = clamp(cell_y, 0, int(height / grid_size) - 1)
	
	# Compute center of that cell
	var snapped_pos = top_left + Vector2(cell_x + 0.5, cell_y + 0.5) * grid_size
	return snapped_pos

func _on_place_unit(pos: Vector2, unit: PackedScene) -> void:
	var cell_center = vector2_to_cell(pos)

	if cell_center in cells:
		print("Cell already occupied!")
		return

	if out_of_bounds(pos):
		print("Out of bounds!")
		return

	var instance = unit.instantiate()
	instance.global_position = cell_center
	add_child(instance)
	cells[cell_center] = instance

func out_of_bounds(pos: Vector2) -> bool:
	if pos.x < top_left.x or pos.x > bottom_right.x:
		return true
	if pos.y < top_left.y or pos.y > bottom_right.y:
		return true
	return false
