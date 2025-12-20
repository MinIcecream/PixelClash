extends Node2D

signal game_over(status: int)
var game_ended = false
@onready var UI = $"../UI"
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	UI.start_game.connect(Callable(self, "_on_start_game"))
	UI.restart_game.connect(Callable(self, "_on_restart_game"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_start_game() -> void:
	game_started = true
	get_tree().paused = false

func _on_restart_game() -> void:
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if game_ended:
		return
	var player_units = get_tree().get_nodes_in_group("player").size()
	var enemy_units = get_tree().get_nodes_in_group("enemy").size()
	
	if player_units > 0 and enemy_units == 0:
		end_game(1)
	if player_units == 0 and enemy_units > 0:
		end_game(-1)
	if player_units == 0 and enemy_units == 0:
		end_game(0)

func end_game(status: int) -> void:
	emit_signal("game_over", status)
	get_tree().paused = true
	game_ended = true
	
	
