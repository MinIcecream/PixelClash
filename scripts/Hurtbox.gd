extends Area2D

var faction

func _ready() -> void:
	faction = get_parent().data.faction
	
func take_damage(amount: int) -> void:
	get_parent().take_damage(amount)

func knockback(force: Vector2) -> void:
	var parent = get_parent()

	parent.velocity = force
	parent.move_and_slide()
	parent.staggered = true

	await get_tree().create_timer(0.5).timeout
	parent.staggered = false
	parent.velocity = Vector2.ZERO
