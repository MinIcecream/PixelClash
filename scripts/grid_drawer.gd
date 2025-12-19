extends Node2D

@export var color: Color = Color(0.7, 0.7, 0.7, 0.5)

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
