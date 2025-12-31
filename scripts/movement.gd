extends Node2D

func separation_force(radius: float) -> Vector2:
	var force := Vector2.ZERO
	var allies = get_tree().get_nodes_in_group(get_parent().group_name)

	for ally in allies:
		if ally == self:
			continue

		var offset = global_position - ally.global_position
		var d = offset.length()

		if d == 0 or d > radius:
			continue

		force += offset.normalized() * (1.0 / d)

	return force

func move_to_target(target: Node, delta: float) -> void:
	if target == null:
		return

	var sep = separation_force(24)
	var to_target = target.global_position - global_position
	var dir = (to_target + sep).normalized()
	var desired_vel = dir * get_parent().data.speed

	# gradually blend current velocity toward desired
	get_parent().velocity = get_parent().velocity.move_toward(desired_vel, 100 * delta)
	get_parent().move_and_slide()
	
