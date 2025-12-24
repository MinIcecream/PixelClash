class_name Projectile

extends Node2D

var target_position
var faction

func set_target_position(node: Node2D):
	target_position = node.global_position

func set_faction(source_faction: UnitData.Faction):
	faction = source_faction
