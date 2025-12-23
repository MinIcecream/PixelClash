extends Attack

@onready var area2D = $"Area2D"

var hit_units := {}

func _ready() -> void:
	area2D.area_entered.connect(Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	var unit = area.get_parent()
	if unit in hit_units or unit.data.faction == self.get_parent().data.faction:
		return

	unit.take_damage(self.get_parent().data.damage)
	hit_units[unit] = true

func _do_attack(_target: Node2D) -> void:
	await get_tree().create_timer(0.5).timeout
	enable_hitbox()
	await get_tree().create_timer(0.2).timeout
	disable_hitbox()
	finish_attack()

func enable_hitbox():
	area2D.monitoring = true
	hit_units = {}

func disable_hitbox():
	area2D.monitoring = false
