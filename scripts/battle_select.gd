extends Control

func _ready() -> void:
	var unlocked_battles = UnlockManager.get_unlocked_battles()
	for button in get_tree().get_nodes_in_group("scene_button"):
		if button.battle.id not in unlocked_battles:
			button.visible = false
