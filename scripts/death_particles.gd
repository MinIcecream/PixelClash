extends Node2D

func _ready() -> void:
	$Timer.timeout.connect(Callable(self, "_on_timeout"))
	$"GPUParticles2D".emitting = true

func _on_timeout():	
	queue_free()
