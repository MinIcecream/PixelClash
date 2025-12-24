@tool
extends Node2D

@export var color: Color = Color(0.7, 0.7, 0.7, 0.5)
@export var grid: Grid

func _draw():
	# Vertical lines
	for i in range(grid.width + 1):
		var x = grid.top_left.x + (grid.cell_size * i)
		var top = grid.top_left.y
		var bottom = grid.top_left.y + (grid.height * grid.cell_size)
		draw_line(Vector2(x, top), Vector2(x, bottom), color, 1)
	# Horizontal lines
	for i in range(grid.height + 1):
		var y = grid.top_left.y + (grid.cell_size * i)
		var left = grid.top_left.x
		var right = grid.top_left.x + (grid.width * grid.cell_size)
		draw_line(Vector2(left, y), Vector2(right, y), color, 1)
