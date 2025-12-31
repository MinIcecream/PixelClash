extends Area2D

var faction

func _ready() -> void:
	faction = get_parent().data.faction
	
func take_damage(amount: int) -> void:
	get_parent().take_damage(amount)

func knockback(force: Vector2) -> void:
	var parent = get_parent()

	parent.velocity += force
	print(force)
	parent.move_and_slide()
	parent.set_collision_mask_value(1, false)
	parent.staggered = true

	await get_tree().create_timer(0.5).timeout

	parent.staggered = false
	parent.set_collision_mask_value(1, true)
