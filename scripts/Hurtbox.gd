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

func knockback(kb: Knockback) -> void:
	get_parent().apply_knockback(kb)

func slow(slow_effect: Slow) -> void:
	get_parent().apply_slow(slow_effect)
