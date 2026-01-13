extends BaseGameManager

@onready var battle_editor = $"../BattleEditor"

func delete_unit(unit: CharacterBody2D) -> void:
	grid.delete_unit(unit)

func _on_back_to_main():
	get_tree().paused = false
	SceneChanger.go_to("res://scenes/battle_select.tscn")

func _setup_game():
	_spawn_enemy_units()

func _spawn_enemy_units():
	var enemy_units = battle_editor.get_enemy_units()
	for pos in enemy_units:
		var unit_data = enemy_units[pos]
		grid.place_unit(pos, unit_data)
