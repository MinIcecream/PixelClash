extends Control

signal start_game
signal restart_game
@onready var game_manager = $"../../GameManager"

func _ready() -> void:
	game_manager.game_over.connect(Callable(self, "_on_game_over"))
	$"Play/Button".pressed.connect(Callable(self, "_on_start_game_pressed"))
	$"GameOver/VBoxContainer/Button".pressed.connect(Callable(self, "_on_restart_game_pressed"))

func _on_start_game_pressed():
	$Play.visible = false
	emit_signal("start_game")
	
func _on_restart_game_pressed() -> void:
	emit_signal("restart_game")

func _on_game_over(status: int) -> void:
	$"GameOver".visible = true
	match status:
		-1:
			$"GameOver/VBoxContainer/Label".text = "You Lost!"
		0:
			$"GameOver/VBoxContainer/Label".text = "You Drew!"
		1:
			$"GameOver/VBoxContainer/Label".text = "You Won!"
