extends Node2D

signal game_over(status: int)
var game_ended = false
@onready var UI = $"../CanvasLayer/Control"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	UI.start_game.connect(Callable(self, "_on_start_game"))
	UI.restart_game.connect(Callable(self, "_on_restart_game"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_start_game() -> void:
	get_tree().paused = false

func _on_restart_game() -> void:
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if game_ended:
		return
	var player_units = get_tree().get_nodes_in_group("player").size()
	var enemy_units = get_tree().get_nodes_in_group("enemy").size()
	
	if player_units > 0 and enemy_units == 0:
		print("won")
		emit_signal("game_over", 1)
		game_ended = true
	if player_units == 0 and enemy_units > 0:
		print("lost")
		emit_signal("game_over", -1)
		game_ended = true
	if player_units == 0 and enemy_units == 0:
		print("draw")
		emit_signal("game_over", 0)
		game_ended = true
	
