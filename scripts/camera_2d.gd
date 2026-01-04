extends Camera2D

@export var zoom_speed := 0.1
@export var min_zoom := 0
@export var max_zoom := 5
var limits_rect: Rect2
@export var grid: Grid
@export var padding: float = 250.0
@export var drag_factor = 0.35

var dragging := false
var drag_start := Vector2.ZERO

func _ready() -> void:
	var width = grid.battle_context.get_grid_width()
	var height = grid.battle_context.get_grid_height()
	var world_rect = Rect2(
		Vector2(0, 0),
		Vector2(width * grid.cell_size, height * grid.cell_size)
	)
	var padding_rect = Rect2(
		world_rect.position - Vector2(padding, padding),
		world_rect.size + Vector2(padding * 2, padding * 2)
	)
	limits_rect = padding_rect
	global_position.x = limits_rect.position.x + limits_rect.size.x / 2
	global_position.y = limits_rect.position.y + limits_rect.size.y / 2

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
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(zoom_speed)

	# Mouse motion while dragging
	elif event is InputEventMouseMotion and dragging:
		position -= event.relative * zoom.x * drag_factor  # scale movement by zoom

func zoom_camera(delta):
	var new_zoom = zoom + Vector2(delta, delta)
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom

func _process(_delta):
	var viewport_size := get_viewport_rect().size / zoom 
	var half_w := viewport_size.x * 0.5
	var half_h := viewport_size.y * 0.5

	var min_x := limits_rect.position.x + half_w
	var max_x := limits_rect.end.x      - half_w
	var min_y := limits_rect.position.y + half_h
	var max_y := limits_rect.end.y      - half_h

	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)
