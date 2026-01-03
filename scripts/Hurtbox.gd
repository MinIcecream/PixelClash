extends Area2D

var faction

var tick_sources: Dictionary[String, float] = {}

func _ready() -> void:
	faction = get_parent().data.faction
	
func take_damage(amount: int) -> void:
	get_parent().take_damage(amount)

func try_take_tick_damage(source_id: String, tick_time: float, damage: int) -> void:
	if source_id not in tick_sources or UnpausedTime.now - tick_sources[source_id] >= tick_time:
		get_parent().take_damage(damage)
		tick_sources[source_id] = UnpausedTime.now

func knockback(source_id: String, force: Vector2) -> void:
	var parent = get_parent()

	parent.velocity = force
	parent.move_and_slide()
	parent.apply_stagger(source_id, 0.5)
	parent.velocity = Vector2.ZERO

func slow(source_id: String, slow_percentage: float, duration: float) -> void:
	get_parent().apply_slow(source_id, slow_percentage, duration)
