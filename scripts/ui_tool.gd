extends PanelContainer
class_name UITool

@onready var parent = $"../../.."
@onready var input_manager = $"../../../../InputManager"
@onready var button = $"MarginContainer/TextureButton"

var selected = false

func _ready() -> void:
	button.pressed.connect(Callable(self, "_on_pressed"))
	button.mouse_entered.connect(Callable(self, "_on_enter"))
	button.mouse_exited.connect(Callable(self, "_on_exit"))

func _on_pressed():
	parent.on_select_tool(self)
	press()

func press():
	pass

func _on_enter():
	self.modulate = Color(0.5, 0.5, 0.5)

func _on_exit():
	if selected:
		return
	self.modulate = Color(1, 1, 1)

func deselect():
	selected = false
	self.modulate = Color(1, 1, 1)

func select():
	selected = true 
	self.modulate = Color(0.5, 0.5, 0.5)
