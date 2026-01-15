extends Control

@export var button_scene: PackedScene
@onready var verticalContainer = $"VBoxContainer"
@export var battle_editor: PackedScene

const BATTLE_DATA_PATH = "res://data/battles/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open(BATTLE_DATA_PATH)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var battle = load(BATTLE_DATA_PATH + file_name) as BattleData
		add_battle_button(battle)
		file_name = dir.get_next()
	dir.list_dir_end()

func add_battle_button(data: BattleData):
	var button = button_scene.instantiate()
	button.setup(data, battle_editor)
	verticalContainer.add_child(button)
	
