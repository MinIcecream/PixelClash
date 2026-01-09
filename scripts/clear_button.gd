extends Button
@onready var grid: Grid = $"../../../Grid"
@onready var game_manager = $"../../../GameManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(Callable(self, "_on_pressed"))

func _on_pressed():
	var units = grid.get_player_units()

	for unit in units:
		game_manager.delete_unit(unit)
