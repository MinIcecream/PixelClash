extends Node2D

func move_to_target(target: Node) -> void:
	if target == null:
		return

	var dir = (target.global_position - global_position).normalized()
	get_parent().velocity = dir * 100
	get_parent().move_and_slide()
	
