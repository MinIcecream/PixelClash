extends Control

func load_scene(scene:PackedScene, battle: BattleData):
	var instance = scene.instantiate()

	var battle_session = instance.get_node("BattleContext")

	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance
