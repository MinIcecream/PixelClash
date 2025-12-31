extends CharacterBody2D

enum Faction { PLAYER, ENEMY, NEUTRAL }

@onready var get_target = $"GetTarget"
@onready var movement = $"Movement"
@onready var attack = $"Attack"
@onready var sprite = $"Sprite2D"
@export var data: Resource

var staggered = false
var origin = Vector2.ZERO
var health

var group_name:
	get:
		match data.faction:
			Faction.PLAYER:
				return "player"
			Faction.ENEMY:
				return "enemy"

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
	
	if target == null or staggered:
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
