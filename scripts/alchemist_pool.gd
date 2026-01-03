extends Node2D

@onready var area2D = $"Area2D"
@onready var timer = $"Timer"
@export var tick_time: float = 0.65
@export var lifetime: float = 3
@export var source_id: String = "alchemist"

var faction
var damage
var enemies: Array[Area2D] = []

func set_faction(source_faction: UnitData.Faction):
	faction = source_faction

func set_damage(damage: int):
	self.damage = damage
	
func _ready() -> void:
	timer.wait_time = tick_time
	timer.timeout.connect(_on_tick)
	timer.start()

	area2D.area_entered.connect(Callable(self, "_on_area_entered"))
	area2D.area_exited.connect(Callable(self, "_on_area_exited"))
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_area_entered(unit: Area2D):
	if unit not in enemies:
		enemies.append(unit)

func _on_area_exited(unit: Area2D):
	if unit in enemies:
		enemies.erase(unit)

func _on_tick():
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.faction != faction:
			enemy.try_take_tick_damage(source_id, tick_time, damage)
			enemy.slow(str(self), 0.6, 1)
