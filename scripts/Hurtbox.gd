extends Area2D

var faction

var tick_sources: Dictionary[String, float] = {}

func _ready() -> void:
	faction = get_parent().data.faction
	
func take_damage(amount: int) -> void:
	get_parent().take_damage(amount)

func try_take_tick_damage(source_id: String, tick_time: float, damage: int) -> void:
	if source_id not in tick_sources or UnpausedTime.now - tick_sources[source_id] >= tick_time:
		print("took tick damage")
		get_parent().take_damage(damage)
		tick_sources[source_id] = UnpausedTime.now

func knockback(force: Vector2) -> void:
	var parent = get_parent()

	parent.velocity = force
	parent.move_and_slide()
	parent.staggered = true

	await get_tree().create_timer(0.5).timeout
	parent.staggered = false
	parent.velocity = Vector2.ZERO
