extends Node2D

var unit: PackedScene = preload("res://scenes/enemy.tscn")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		spawn_at_mouse()

func spawn_at_mouse():
	var instance = unit.instantiate()
	instance.global_position = get_global_mouse_position()
	add_child(instance)
