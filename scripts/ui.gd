extends BaseUI

signal start_game
signal restart_game

@onready var game_manager = $"../GameManager"
@onready var gold_manager = $"../GoldManager"
@onready var input_manager = $"../InputManager"
@onready var play_button = $"Control/Play/HBoxContainer/Button"
@onready var gold_label = $"Control/Play/HBoxContainer/MarginContainer/Gold"
@onready var restart_button = $"Control/GameOver/VBoxContainer/Button"
@onready var game_over_label = $"Control/GameOver/VBoxContainer/Label"
@onready var play_container = $"Control/Play"
@onready var game_over_container = $"Control/GameOver"
@onready var preview_gold = $"Control/PreviewGold"
@onready var toolbar = $"Control/HBoxContainer"
@onready var clear_all_button = $"Control/ClearButton"
@onready var leave_battle_button = $"Control/LeaveBattleButton"

func _connect_signals() -> void:
	input_manager.preview_gold.connect(Callable(self, "_on_preview_gold"))
	input_manager.clear_preview_gold.connect(Callable(self, "_on_clear_preview_gold"))
	game_manager.game_over.connect(Callable(self, "_on_game_over"))
	gold_manager.gold_changed.connect(Callable(self, "_on_gold_changed"))
	play_button.pressed.connect(Callable(self, "_on_start_game_pressed"))
	restart_button.pressed.connect(Callable(self, "_on_restart_game_pressed"))

func _setup_ui():
	gold_label.text = str(gold_manager.gold) + " Gold"
	
	var unlocked_units = UnlockManager.get_unlocked_units()
	for button in get_tree().get_nodes_in_group("unit_button"):
		if button.unit.name not in unlocked_units:
			button.panel.visible = false

func _on_game_over(status: int) -> void:
	game_over_container.visible = true
	back_button.visible = true
	match status:
		-1:
			game_over_label.text = "You Lost!"
		0:
			game_over_label.text = "You Drew!"
		1:
			game_over_label.text = "You Won!"

func _on_gold_changed(gold: int):
	gold_label.text = str(gold) + " Gold"

func _on_start_game_pressed():
	play_container.visible = false
	toolbar.visible = false
	clear_all_button.visible = false
	emit_signal("start_game")
	back_button.visible = false
	leave_battle_button.visible = true
	
func _on_restart_game_pressed() -> void:
	emit_signal("restart_game")

func _on_preview_gold(gold) -> void:
	preview_gold.visible = true
	preview_gold.text = str(gold) + " gold"

	var mouse_pos := get_viewport().get_mouse_position()
	preview_gold.global_position = mouse_pos + Vector2(24, -14)

func _on_clear_preview_gold() -> void:
	preview_gold.visible = false
