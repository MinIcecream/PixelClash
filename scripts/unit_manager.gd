extends CharacterBody2D

enum Faction { PLAYER, ENEMY, NEUTRAL }

@onready var get_target = $"GetTarget"
@onready var movement = $"Movement"
@onready var attack = $"Attack"
@onready var sprite = $"Sprite2D"
@export var data: Resource

var stagger_sources: Dictionary[String, float]
var slow_sources: Dictionary[String, Array] # {source: [slow_amount, end_time]}
var origin = Vector2.ZERO
var health

var group_name:
	get:
		match data.faction:
			Faction.PLAYER:
				return "player"
			Faction.ENEMY:
				return "enemy"

var slow:
	get:
		var max_slow = 0
		for source in slow_sources:
			max_slow = max(max_slow, slow_sources[source][0])
		return max_slow

func _ready():
	health = data.health

	match data.faction:
		Faction.PLAYER:
			add_to_group("player")
		Faction.ENEMY:
			add_to_group("enemy")


func _process(delta: float) -> void:
	var target_groups = data.target_groups
	var target = get_target.get_target(target_groups)
	cleanse_expired_cc()

	if target == null or stagger_sources.size() > 0 or attack.can_attack == false:
		return

	if self.global_position.distance_to(target.global_position) < data.attack_range:
		attack.attack(target)
	else:
		movement.move_to_target(target, delta)

func take_damage(amount: int) -> void:
	health -= amount
	flash_red()
	if health <= 0:
		var death_particles = data.death_particles.instantiate()
		death_particles.global_position = global_position
		get_tree().current_scene.add_child(death_particles)
		queue_free()

func flash_red():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func cleanse_expired_cc() -> void:
	for source in stagger_sources.keys():
		if UnpausedTime.now > stagger_sources[source]:
			stagger_sources.erase(source)
	for source in slow_sources.keys():
		if UnpausedTime.now > slow_sources[source][1]:
			slow_sources.erase(source)

func apply_slow(source_id: String, slow_amount: float, duration: float) -> void:
	var end_time = UnpausedTime.now + duration
	slow_sources[source_id] = [slow_amount, end_time]

func apply_stagger(source_id: String, duration: float) -> void:
	var end_time = UnpausedTime.now + duration
	stagger_sources[source_id] = end_time
