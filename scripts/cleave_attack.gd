extends MeleeAttack

func _apply_hit_effects(unit: Area2D) -> void:
	var dir = (unit.global_position - global_position).normalized()

	var chaos = randf_range(-0.3, 0.3)
	dir = dir.rotated(chaos)
	var knockback = Knockback.new(dir * 1300)
	unit.knockback(knockback)
