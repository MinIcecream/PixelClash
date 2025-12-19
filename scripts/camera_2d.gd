@tool
extends Camera2D

@export var zoom_speed := 0.1
@export var min_zoom := 0.1
@export var max_zoom := 5
@export var limits_rect := Rect2(Vector2.ZERO, Vector2(1000, 1000))

var dragging := false
var drag_start := Vector2.ZERO

func _input(event):
	# Start drag on right mouse button down
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				dragging = true
				drag_start = event.position
			else:
				dragging = false

		# Zoom in/out with scroll wheel
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)

	# Mouse motion while dragging
	elif event is InputEventMouseMotion and dragging:
		position -= event.relative * zoom.x  # scale movement by zoom

func zoom_camera(delta):
	var new_zoom = zoom + Vector2(delta, delta)
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom

func _process(_delta):
	position.x = clamp(position.x, limits_rect.position.x, limits_rect.position.x + limits_rect.size.x)
	position.y = clamp(position.y, limits_rect.position.y, limits_rect.position.y + limits_rect.size.y)
