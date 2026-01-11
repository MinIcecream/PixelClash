extends Node2D

signal game_over(status: int)

var game_ended = false
@onready var UI = $"../UI"
@onready var grid = $"../Grid"
@onready var gold_manager = $"../GoldManager"

var game_started = false
@export var battle_context: BattleContext

func _ready() -> void:
	_spawn_enemy_units()
	get_tree().paused = true
	UI.back_to_main.connect(Callable(self, "_on_back_to_main"))
	UI.start_game.connect(Callable(self, "_on_start_game"))
	UI.restart_game.connect(Callable(self, "restart_game"))
	
	var starting_gold = battle_context.get_starting_gold()
	for pos in BattleSession.battle_state.player_units:
		var unit_data = BattleSession.battle_state.player_units[pos]
		starting_gold -= unit_data.price
		grid.place_unit(pos, unit_data)
	
	gold_manager.set_gold(starting_gold)

func _spawn_enemy_units():
	var enemy_units = battle_context.get_enemy_units()

	for pos in enemy_units:
		var unit_data = enemy_units[pos]
		print(unit_data)
		var unit_scene = UnitRegistry.units[unit_data.name].scene
		var instance = unit_scene.instantiate()
		instance.global_position = grid.world_pos_to_spawn_unit(pos, unit_data)
		self.add_child(instance)

func _on_start_game() -> void:
	game_started = true
	_save_battle_state()
	get_tree().paused = false

func restart_game() -> void:
	SceneChanger.reload_battle()

func _process(_delta: float) -> void:
	if game_ended:
		return
	var player_units = get_tree().get_nodes_in_group("player").size()
	var enemy_units = get_tree().get_nodes_in_group("enemy").size()
	
	if player_units > 0 and enemy_units == 0:
		UnlockManager.unlock_after_battle(battle_context.battle_data.id)
		_end_game(1)
	if player_units == 0 and enemy_units > 0:
		_end_game(-1)
	if player_units == 0 and enemy_units == 0:
		_end_game(0)

func _end_game(status: int) -> void:
	emit_signal("game_over", status)
	get_tree().paused = true
	game_ended = true

func _on_back_to_main():
	get_tree().paused = false
	BattleSession.battle_state.player_units.clear()
	SceneChanger.go_to("res://scenes/battle_select.tscn")

func _save_battle_state():
	var state := BattleSession.battle_state
	state.player_units.clear()
	for pos in grid.used_cells:
		var origin = grid.used_cells[pos].origin
		state.player_units[origin] = grid.used_cells[pos].data

func delete_unit(unit: CharacterBody2D) -> void:
	var gold_refunded = unit.data.price
	grid.delete_unit(unit)
	gold_manager.add_gold(gold_refunded)
