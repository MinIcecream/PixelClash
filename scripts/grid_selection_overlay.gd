@tool
extends Node2D

@export var color: Color = Color(0.7, 0.7, 0.7, 0.5)
@export var grid: Node2D
@onready var input_manager = $"../../InputManager"
const valid_selection_color: Color = Color(0.2, 0.8, 0.2, 0.5)
const invalid_selection_color: Color = Color(0.9, 0.3, 0.3, 0.5)
var selection_color = valid_selection_color
var selection = null

func _ready():
	input_manager.select_cells.connect(Callable(self, "_on_select_cells"))
	input_manager.preview_gold.connect(Callable(self, "_on_preview_gold"))
	
func _draw():
	if selection != null:
		draw_selection_box(selection[0], selection[1])
	
func draw_selection_box(first_coord, second_coord):
	var cell1 = grid.world_to_cell(first_coord)
	var cell2 = grid.world_to_cell(second_coord)
	var curr_grid = grid.playable_grid

	var top_cell_pos = min(cell1.y, cell2.y)
	var bottom_cell_pos = max(cell1.y, cell2.y)
	var left_cell_pos = min(cell1.x, cell2.x)
	var right_cell_pos = max(cell1.x, cell2.x)
	
	if top_cell_pos < curr_grid.position.y and bottom_cell_pos < curr_grid.position.y:
		return
	if top_cell_pos > curr_grid.end.y and bottom_cell_pos > curr_grid.end.y:
		return
	if left_cell_pos < curr_grid.position.x and right_cell_pos < curr_grid.position.x:
		return
	if left_cell_pos > curr_grid.end.x and right_cell_pos > curr_grid.end.x:
		return
	
	top_cell_pos = clamp(top_cell_pos, curr_grid.position.y, curr_grid.end.y - 1)
	bottom_cell_pos = clamp(bottom_cell_pos, curr_grid.position.y, curr_grid.end.y - 1)
	left_cell_pos = clamp(left_cell_pos, curr_grid.position.x, curr_grid.end.x - 1)
	right_cell_pos = clamp(right_cell_pos, curr_grid.position.x, curr_grid.end.x - 1)
	
	var top_left_cell_bounds = grid.get_cell_bounds(Vector2i(left_cell_pos, top_cell_pos))
	var bottom_right_cell_bounds = grid.get_cell_bounds(Vector2i(right_cell_pos, bottom_cell_pos))
	
	var top_world_pos = top_left_cell_bounds.position.y
	var bottom_world_pos = bottom_right_cell_bounds.position.y + bottom_right_cell_bounds.size.y
	var left_world_pos = top_left_cell_bounds.position.x
	var right_world_pos = bottom_right_cell_bounds.position.x + bottom_right_cell_bounds.size.x

	draw_line(Vector2(left_world_pos, top_world_pos), Vector2(right_world_pos, top_world_pos), selection_color, 3)
	draw_line(Vector2(right_world_pos, top_world_pos), Vector2(right_world_pos, bottom_world_pos), selection_color, 3)
	draw_line(Vector2(right_world_pos, bottom_world_pos), Vector2(left_world_pos, bottom_world_pos), selection_color, 3)
	draw_line(Vector2(left_world_pos, bottom_world_pos), Vector2(left_world_pos, top_world_pos), selection_color, 3)

func _on_select_cells(coords: PackedVector2Array):
	if coords.size() == 0:
		selection = null
		queue_redraw()
		return

	selection = coords
	queue_redraw()

func _on_preview_gold(gold: int):
	if gold < 0:
		selection_color = invalid_selection_color
	else:
		selection_color = valid_selection_color
