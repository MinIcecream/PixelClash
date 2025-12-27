extends Node

var battle_state: BattleState

func _ready() -> void:
	BattleSession.battle_state = BattleState.new()
