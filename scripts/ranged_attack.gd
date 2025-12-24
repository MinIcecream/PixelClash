extends Attack

@export var projectile: PackedScene

func _do_attack(target: Node2D):
	var instance = projectile.instantiate()
	instance.global_position = self.global_position
	get_tree().current_scene.add_child(instance)
	instance.set_target_position(target)
	instance.set_faction(get_parent().data.faction)
	finish_attack()
