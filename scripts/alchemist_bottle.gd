extends Projectile

@onready var area2D = $"Area2D"
@export var lifeTime = 2
@export var target_radius = 4
@export var speed = 240
@export var pool: PackedScene

func _ready() -> void:
	await get_tree().create_timer(lifeTime).timeout
	queue_free()

func _physics_process(delta: float) -> void:	
	if global_position.distance_to(target_position) <= target_radius:
		var instance = pool.instantiate()
		instance.global_position = self.global_position
		instance.set_faction(faction)
		get_tree().current_scene.add_child(instance)
		queue_free()

	var dir = (target_position - self.global_position).normalized()
	
	rotation = dir.angle() + deg_to_rad(90)
	global_position += dir * delta * speed
