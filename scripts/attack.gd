extends Area2D

signal finish_attack

@onready var collider = "$Collider"

var hit_units := {}

func _ready() -> void:
	self.area_entered.connect(Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	var unit = area.get_parent()
	if unit in hit_units or unit.data.faction == self.get_parent().data.faction:
		return

	unit.take_damage(self.get_parent().data.damage)
	hit_units[unit] = true

func attack() -> void:
	await get_tree().create_timer(0.5).timeout
	enable_hitbox()
	await get_tree().create_timer(0.2).timeout
	disable_hitbox()
	emit_signal("finish_attack")

func enable_hitbox():
	monitoring = true
	hit_units = {}

func disable_hitbox():
	monitoring = false
