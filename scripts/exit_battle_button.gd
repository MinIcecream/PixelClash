extends TextureButton
@onready var game_manager = $"../../../GameManager"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(Callable(self, "_on_pressed"))
	
func _on_pressed() -> void:
	game_manager.restart_game()
