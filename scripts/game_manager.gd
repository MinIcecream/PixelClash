extends Node2D

signal game_over(status: int)

var game_ended = false
@onready var UI = $"../UI"
@onready var grid = $"../Grid"
@onready var gold_manager = $"../GoldManager"

var game_started = false
@export var battle_context: BattleContext

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_enemy_units()
	get_tree().paused = true
	UI.back_to_main.connect(Callable(self, "_on_back_to_main"))
	UI.start_game.connect(Callable(self, "_on_start_game"))
	UI.restart_game.connect(Callable(self, "_on_restart_game"))
	grid.place_unit.connect(Callable(self, "_on_place_unit"))
	
	var starting_gold = battle_context.get_starting_gold()
	for pos in BattleSession.battle_state.player_units:
		var unit_name = BattleSession.battle_state.player_units[pos]
		var cost = UnitRegistry.units[unit_name].data.price
		var scene = UnitRegistry.units[unit_name].scene
		starting_gold -= cost
		var instance = scene.instantiate()
		instance.global_position = pos
		self.add_child(instance)
	
	gold_manager.set_gold(starting_gold)


func _spawn_enemy_units():
	var enemy_units = battle_context.get_enemy_units()
	for pos in enemy_units:
		var unit_data = enemy_units[pos]
		var unit_scene = UnitRegistry.units[unit_data.name].scene
		var instance = unit_scene.instantiate()
		instance.global_position = grid.cell_to_world(pos)
		self.add_child(instance)

func _on_start_game() -> void:
	game_started = true
	_save_battle_state()
	get_tree().paused = false

func _on_restart_game() -> void:
	get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	if game_ended:
		return
	var player_units = get_tree().get_nodes_in_group("player").size()
	var enemy_units = get_tree().get_nodes_in_group("enemy").size()
	
	if player_units > 0 and enemy_units == 0:
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

	for unit in get_tree().get_nodes_in_group("player"):
		state.player_units[unit.global_position] = unit.data.name
