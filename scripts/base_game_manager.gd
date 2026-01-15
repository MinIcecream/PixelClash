extends Node2D
class_name BaseGameManager

var game_started = false
@onready var UI = $"../UI"
@onready var grid = $"../Grid"

func _ready() -> void:
	get_tree().paused = true
	UI.back_to_main.connect(Callable(self, "_on_back_to_main"))
	_connect_signals()
	_setup_game()

func _connect_signals() -> void:
	pass

func _setup_game():
	pass
