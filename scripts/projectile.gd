class_name Projectile

extends Node2D

var target_position
var faction
var damage

func set_target_position(node: Node2D):
	target_position = node.global_position

func set_faction(source_faction: UnitData.Faction):
	faction = source_faction

func set_damage(damage: int):
	self.damage = damage
