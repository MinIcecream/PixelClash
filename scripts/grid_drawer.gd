@tool
extends Node2D

@export var light_color: Color = Color(0.7, 0.7, 0.7, 0.2)
@export var color: Color = Color(0.7, 0.7, 0.7, 0.5)
@export var grid: Grid

func _draw():
	_draw_grid_lines()
	_draw_player_grid_outline()

func _draw_grid_lines():
	# Vertical lines
	var width = grid.battle_context.get_grid_width()
	var height = grid.battle_context.get_grid_height()

	for i in range(width + 1):
		var x = grid.cell_size * i
		var bottom = height * grid.cell_size
		draw_line(Vector2(x, 0), Vector2(x, bottom), color, 1)
	# Horizontal lines
	for i in range(height + 1):
		var y = grid.cell_size * i
		var right = width * grid.cell_size
		draw_line(Vector2(0, y), Vector2(right, y), color, 1)

func _draw_player_grid_outline():
	var cell_rect = grid.battle_context.get_player_grid()
	var world_rect = Rect2(
		cell_rect.position * grid.cell_size,
		cell_rect.size * grid.cell_size)
	draw_rect(world_rect, Color.RED, false, 2.0)
