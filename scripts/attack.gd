class_name Attack

extends Node2D

# currently attacking OR on cooldown
var can_attack = true

# currently attacking
var attacking = false

func attack(target: Node2D) -> void:
	if not can_attack:
		return
	can_attack = false
	attacking = true
	_do_attack(target)

func _do_attack(_target: Node2D) -> void:
	pass

func finish_attack():
	attacking = false
	var cooldown = get_parent().data.attack_cooldown * randf_range(0.95, 1.05)
	await get_tree().create_timer(cooldown).timeout
	can_attack = true
