extends Node

var current_battle: BattleData
var current_battle_scene: PackedScene

func go_to_packed(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)

func go_to(path: String):
	get_tree().change_scene_to_file(path)
	
func load_battle(scene: PackedScene, battle: BattleData):
	current_battle = battle
	current_battle_scene = scene
	var instance = scene.instantiate()
	var battle_context = instance.get_node("BattleContext")
	battle_context.set_battle_data(current_battle)
	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance

func load_battle_editor(scene: PackedScene, battle: BattleData):
	var instance = scene.instantiate()
	var battle_editor = instance.get_node("BattleEditor")
	battle_editor.set_battle_data(battle)
	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance

func reload_battle():
	var instance = current_battle_scene.instantiate()
	var battle_context = instance.get_node("BattleContext")
	battle_context.set_battle_data(current_battle)
	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance
