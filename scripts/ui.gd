extends CanvasLayer

signal start_game
signal restart_game
signal select_unit

@onready var game_manager = $"../GameManager"
@onready var play_button = $"Control/Play/HBoxContainer/Button"
@onready var gold_label = $"Control/Play/HBoxContainer/MarginContainer/Gold"
@onready var restart_button = $"Control/GameOver/VBoxContainer/Button"
@onready var game_over_label = $"Control/GameOver/VBoxContainer/Label"
@onready var play_container = $"Control/Play"
@onready var game_over_container = $"Control/GameOver"

func _ready() -> void:
	game_manager.game_over.connect(Callable(self, "_on_game_over"))
	game_manager.update_gold.connect(Callable(self, "_on_update_gold"))
	play_button.pressed.connect(Callable(self, "_on_start_game_pressed"))
	restart_button.pressed.connect(Callable(self, "_on_restart_game_pressed"))

func _on_game_over(status: int) -> void:
	game_over_container.visible = true
	match status:
		-1:
			game_over_label.text = "You Lost!"
		0:
			game_over_label.text = "You Drew!"
		1:
			game_over_label.text = "You Won!"

func _on_update_gold(gold: int):
	gold_label.text = str(gold) + " gold"

func _on_start_game_pressed():
	play_container.visible = false
	emit_signal("start_game")
	
func _on_restart_game_pressed() -> void:
	emit_signal("restart_game")
	
func on_select_unit(selected_button: TextureButton) -> void:
	for button in get_tree().get_nodes_in_group("unit_button"):
		if button != selected_button:
			button.lighten()
	selected_button.darken()
	emit_signal("select_unit", selected_button.unit)
