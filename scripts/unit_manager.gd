extends CharacterBody2D

enum Faction { PLAYER, ENEMY, NEUTRAL }

@onready var get_target = $"GetTarget"
@onready var movement = $"Movement"
@onready var attack = $"Attack"

@export var data: Resource

var attacking = false
var can_attack = true

var health

func _ready():
	health = data.health
	attack.connect("finish_attack", Callable(self, "_on_finish_attack"))

	match data.faction:
		Faction.PLAYER:
			add_to_group("player")
		Faction.ENEMY:
			add_to_group("enemy")


func _process(_delta: float) -> void:
	if attacking:
		return

	var target_groups = data.target_groups
	var target = get_target.get_target(target_groups)
	
	if target == null:
		return

	if self.global_position.distance_to(target.global_position) < data.attack_range:
		if can_attack and not attacking:
			attack.attack();
			can_attack = false
			attacking = true
	else:
		movement.move_to_target(target)

func _on_finish_attack():	
	attacking = false
	await get_tree().create_timer(data.attack_cooldown).timeout
	can_attack = true

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
