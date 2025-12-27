extends Node

func go_to_packed(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)

func go_to(path: String):
	get_tree().change_scene_to_file(path)
	
