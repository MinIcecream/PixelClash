class_name Attack

extends Node2D

var _can_attack = true

func attack(target: Node2D) -> void:
	if not _can_attack:
		return
	_can_attack = false
	_do_attack(target)

func _do_attack(_target: Node2D) -> void:
	pass

func finish_attack():
	await get_tree().create_timer(get_parent().data.attack_cooldown).timeout
	_can_attack = true
