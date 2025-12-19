extends Node2D

var unit: PackedScene = preload("res://scenes/knight.tscn")
signal place_unit(position: Vector2, unit_scene: PackedScene)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		spawn_at_mouse()

func spawn_at_mouse():
	emit_signal("place_unit", get_global_mouse_position(), unit)
