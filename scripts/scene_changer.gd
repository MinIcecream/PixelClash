extends Node

func go_to_packed(scene: PackedScene):	
	BattleSession.battle_state.player_units.clear()
	get_tree().change_scene_to_packed(scene)

func go_to(path: String):
	BattleSession.battle_state.player_units.clear()
	get_tree().change_scene_to_file(path)
	
