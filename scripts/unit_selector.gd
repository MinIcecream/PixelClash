extends TextureButton

@export var unit: UnitData
@export var icon: CompressedTexture2D

@onready var panel = $"../.."
@onready var parent = $"../../../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_normal = icon
	pressed.connect(Callable(self, "_on_pressed"))
	mouse_entered.connect(Callable(self, "_on_enter"))
	mouse_exited.connect(Callable(self, "_on_exit"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_pressed():
	parent.on_select_unit(self)

func _on_enter():
	panel.modulate = Color(0.5, 0.5, 0.5)

func _on_exit():
	panel.modulate = Color(1, 1, 1)

func darken():
	self.modulate = Color(0.5, 0.5, 0.5)

func lighten():
	self.modulate = Color(1, 1, 1)
