extends Node2D

@export var color: Color = Color(0.7, 0.7, 0.7, 0.5)

func _draw():
	# Vertical lines
	for x in range(get_parent().top_left.x, get_parent().top_left.x + get_parent().width + 1, get_parent().grid_size):
		draw_line(Vector2(x, get_parent().top_left.y), Vector2(x, get_parent().top_left.y + get_parent().height), color, 1)
	# Horizontal lines
	for y in range(get_parent().top_left.y, get_parent().top_left.y + get_parent().height + 1, get_parent().grid_size):
		draw_line(Vector2(get_parent().top_left.x, y), Vector2(get_parent().top_left.x + get_parent().width, y), color, 1)
