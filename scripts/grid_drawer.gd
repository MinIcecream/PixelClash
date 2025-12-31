@tool
extends Node2D

@export var light_color: Color = Color(0.7, 0.7, 0.7, 0.2)
@export var color: Color = Color(0.7, 0.7, 0.7, 0.5)
@export var grid: Grid

func _draw():
	if Engine.is_editor_hint():
		_draw_all_grid_lines()
		_draw_player_grid_outline()
	else:
		_draw_player_grid_lines()

func _draw_all_grid_lines():
	_draw_grid_lines(Rect2i(Vector2(0, 0), Vector2(grid.width, grid.height)))

func _draw_player_grid_lines():
	_draw_grid_lines(grid.player_grid)

func _draw_grid_lines(rect: Rect2i):
	# Vertical lines
	for i in range(rect.position.x, rect.position.x + rect.size.x + 1):
		var x = grid.cell_size * i
		var top = rect.position.y * grid.cell_size
		var bottom = top + rect.size.y * grid.cell_size
		draw_line(Vector2(x, top), Vector2(x, bottom), color, 1)
	# Horizontal lines
	for i in range(rect.position.y, rect.position.y + rect.size.y + 1):
		var y = grid.cell_size * i
		var left = rect.position.x * grid.cell_size
		var right = left + rect.size.x * grid.cell_size
		draw_line(Vector2(left, y), Vector2(right, y), color, 1)

func _draw_player_grid_outline():
	var cell_rect = grid.player_grid
	var world_rect = Rect2(
		cell_rect.position * grid.cell_size,
		cell_rect.size * grid.cell_size)
	draw_rect(world_rect, Color.RED, false, 2.0)
