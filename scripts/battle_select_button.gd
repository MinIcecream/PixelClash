extends Button

@onready var parent = $"../.."
@export var scene: PackedScene
@export var battle: BattleData

func _ready() -> void:
	pressed.connect(Callable(self, "_on_pressed"))

func _on_pressed():
	parent.load_scene(scene, battle)
