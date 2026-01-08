extends Node2D
@onready var avoidance_area = $"../AvoidanceArea"

func separation_force() -> Vector2:
	var force := Vector2.ZERO
	for body in avoidance_area.get_overlapping_areas():
		var parent = body.get_parent()
		if parent == self or not parent.is_in_group(get_parent().group_name):
			continue

		var offset = global_position - parent.global_position
		var d = offset.length()

		if d == 0:
			continue

		force += offset.normalized() * (1.0 / d)
	return force

func get_desired_velocity(target: Node) -> Vector2:
	if target == null or get_parent().in_range:
		return Vector2.ZERO
	var sep = separation_force()
	var to_target = target.global_position - global_position
	var dir = (to_target + sep * 1000).normalized()
	var desired = dir * get_parent().data.speed * (1 - get_parent().slow)
	return desired	
