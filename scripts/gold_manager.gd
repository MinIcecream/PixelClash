extends Node

signal gold_changed(new_value: int)
@export var starting_gold = 0

var gold: int:
	get:
		return gold
	set(value):
		gold = value
		gold_changed.emit(gold)

func _ready() -> void:
	gold = starting_gold

func get_gold():
	return gold

func set_gold(new_amt: int):
	gold = new_amt

func add_gold(amount: int):
	gold += amount

func spend_gold(amount: int):
	gold -= amount
