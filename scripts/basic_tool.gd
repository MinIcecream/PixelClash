extends UITool
class_name BasicTool
@export var icon: CompressedTexture2D

func _ready() -> void:
	super._ready()
	button.texture_normal = icon
