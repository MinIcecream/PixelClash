extends Control

func _ready() -> void:
	var unlocked_battles = UnlockManager.get_unlocked_battles()
	for button in get_tree().get_nodes_in_group("scene_button"):
		if button.battle.id not in unlocked_battles:
			button.visible = false

func load_scene(scene:PackedScene, battle: BattleData):
	var instance = scene.instantiate()
	var battle_context = instance.get_node("BattleContext")
	battle_context.battle_data = battle
	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance
