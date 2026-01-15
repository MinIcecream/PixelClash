extends Button

var battle_data: BattleData
var battle_editor: PackedScene

func setup(data: BattleData, _battle_editor: PackedScene):
	battle_data = data
	text = data.id
	battle_editor = _battle_editor

func _pressed() -> void:
	SceneChanger.load_battle_editor(battle_editor, battle_data)
