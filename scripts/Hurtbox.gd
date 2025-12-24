extends Area2D

var faction

func _ready() -> void:
	faction = get_parent().data.faction
	
func take_damage(amount: int) -> void:
	get_parent().take_damage(amount)
