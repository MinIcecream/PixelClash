extends Node2D

var unit: PackedScene = preload("res://scenes/knight.tscn")
signal place_unit(position: Vector2, unit_scene: PackedScene)
var start = null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start = get_global_mouse_position()
		else:
			if start == null:
				return
			var stop = get_global_mouse_position()
			spawn_at_mouse(start, stop)
			start = null

func spawn_at_mouse(start, stop):
	emit_signal("place_unit", start, stop, unit)
