extends CanvasLayer

signal start_game
signal restart_game
@onready var game_manager = $"../GameManager"
@onready var play_button = $"Control/Play/Button"
@onready var restart_button = $"Control/GameOver/VBoxContainer/Button"
@onready var game_over_label = $"Control/GameOver/VBoxContainer/Label"
@onready var play_container = $"Control/Play"
@onready var game_over_container = $"Control/GameOver"

func _ready() -> void:
	game_manager.game_over.connect(Callable(self, "_on_game_over"))
	play_button.pressed.connect(Callable(self, "_on_start_game_pressed"))
	restart_button.pressed.connect(Callable(self, "_on_restart_game_pressed"))

func _on_start_game_pressed():
	play_container.visible = false
	emit_signal("start_game")
	
func _on_restart_game_pressed() -> void:
	emit_signal("restart_game")

func _on_game_over(status: int) -> void:
	game_over_container.visible = true
	match status:
		-1:
			game_over_label.text = "You Lost!"
		0:
			game_over_label.text = "You Drew!"
		1:
			game_over_label.text = "You Won!"
