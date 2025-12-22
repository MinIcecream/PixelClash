extends Node2D

@export var color: Color = Color(0.7, 0.7, 0.7, 0.5)
var selection = null
@onready var input_manager = $"../../InputManager"

func _ready() -> void:
	input_manager.selection.connect(Callable(self, "_on_select"))

func _draw():
	# Vertical lines
	for i in range(get_parent().width + 1):
		var x = get_parent().top_left.x + (get_parent().cell_size * i)
		var top = get_parent().top_left.y
		var bottom = get_parent().top_left.y + (get_parent().height * get_parent().cell_size)
		draw_line(Vector2(x, top), Vector2(x, bottom), color, 1)
	# Horizontal lines
	for i in range(get_parent().height + 1):
		var y = get_parent().top_left.y + (get_parent().cell_size * i)
		var left = get_parent().top_left.x
		var right = get_parent().top_left.x + (get_parent().width * get_parent().cell_size)
		draw_line(Vector2(left, y), Vector2(right, y), color, 1)
	if selection != null:
		draw_selection_box(selection[0], selection[1])
	
func draw_selection_box(first_coord, second_coord):
	print("hi")
	var cell1 = get_parent().world_to_cell(first_coord)
	var cell2 = get_parent().world_to_cell(second_coord)
	
	var top_cell_pos = min(cell1.y, cell2.y)
	var bottom_cell_pos = max(cell1.y, cell2.y)
	var left_cell_pos = min(cell1.x, cell2.x)
	var right_cell_pos = max(cell1.x, cell2.x)

	var top_left_cell_bounds = get_parent().get_cell_bounds(Vector2i(left_cell_pos, top_cell_pos))
	var bottom_right_cell_bounds = get_parent().get_cell_bounds(Vector2i(right_cell_pos, bottom_cell_pos))
	
	var top_world_pos = top_left_cell_bounds.position.y
	var bottom_world_pos = bottom_right_cell_bounds.position.y + bottom_right_cell_bounds.size.y
	var left_world_pos = top_left_cell_bounds.position.x
	var right_world_pos = bottom_right_cell_bounds.position.x + bottom_right_cell_bounds.size.x

	draw_line(Vector2(left_world_pos, top_world_pos), Vector2(right_world_pos, top_world_pos), color, 3)
	draw_line(Vector2(right_world_pos, top_world_pos), Vector2(right_world_pos, bottom_world_pos), color, 3)
	draw_line(Vector2(right_world_pos, bottom_world_pos), Vector2(left_world_pos, bottom_world_pos), color, 3)
	draw_line(Vector2(left_world_pos, bottom_world_pos), Vector2(left_world_pos, top_world_pos), color, 3)

func _on_select(start: Vector2, stop: Vector2):
	selection = [start, stop]
	queue_redraw()
