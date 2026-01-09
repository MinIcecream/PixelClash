extends CharacterBody2D

enum Faction { PLAYER, ENEMY, NEUTRAL }

@onready var get_target = $"GetTarget"
@onready var movement = $"Movement"
@onready var attack = $"Attack"
@onready var sprite = $"Sprite2D"
@export var data: Resource

var additive_ccs: Array = []
var movement_modifier_ccs: Array = []
var origin = Vector2.ZERO
var health
var in_range: bool = false

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
		for effect in movement_modifier_ccs:
			max_slow = max(max_slow, effect.get_velocity_modifier())
		return max_slow

func _ready():
	health = data.health

	match data.faction:
		Faction.PLAYER:
			add_to_group("player")
		Faction.ENEMY:
			add_to_group("enemy")


func _process(_delta: float) -> void:
	var target_groups = data.target_groups
	var target = get_target.get_target(target_groups)

	# check if attacking so you don't apply a movement velocity if the attack takes you out of range
	if target == null or attack.attacking == true:
		return

	if self.global_position.distance_to(target.global_position) < data.attack_range:
		attack.attack(target)
		in_range = true
	else:
		in_range = false

func _physics_process(_delta: float) -> void:
	var total_velocity = Vector2.ZERO

	for modifier in movement_modifier_ccs:
		if modifier.is_completed():
			movement_modifier_ccs.erase(modifier)

	var desired_velocity = movement.get_desired_velocity(get_target.get_target(data.target_groups))
	total_velocity += desired_velocity

	for cc in additive_ccs:
		total_velocity += cc.get_velocity() / data.mass
		if cc.is_completed():
			additive_ccs.erase(cc)

	velocity = total_velocity
	move_and_slide()

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

func apply_slow(_slow: Slow) -> void:
	movement_modifier_ccs.append(_slow)

func apply_stagger(stagger: Stagger) -> void:
	movement_modifier_ccs.append(stagger)

func apply_knockback(knockback: Knockback) -> void:
	additive_ccs.append(knockback)
