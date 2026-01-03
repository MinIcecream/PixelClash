extends Node2D
@onready var avoidance_area = $"../AvoidanceArea"

func separation_force() -> Vector2:
	var force := Vector2.ZERO
	for body in avoidance_area.get_overlapping_bodies():
		if body == self or not body.is_in_group(get_parent().group_name):
			continue

		var offset = global_position - body.global_position
		var d = offset.length()

		if d == 0:
			continue

		force += offset.normalized() * (1.0 / d)
	return force

func move_to_target(target: Node, delta: float) -> void:
	if target == null:
		return
	var sep = separation_force()
	var to_target = target.global_position - global_position
	var dir = (to_target + sep * 1000).normalized()
	var desired = dir * get_parent().data.speed * (1 - get_parent().slow)
	get_parent().velocity = get_parent().velocity.lerp(desired, 8.0 * delta)
	get_parent().move_and_slide()
	
