extends Projectile

@onready var area2D = $"Area2D"
@export var lifeTime = 10
@export var target_radius = 2
@export var speed = 240

func _ready() -> void:
	area2D.area_entered.connect(Callable(self, "_on_area_entered"))
	await get_tree().create_timer(lifeTime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var dir = (target_position - self.global_position).normalized()
	
	rotation = dir.angle() + deg_to_rad(90)
	global_position += dir * delta * speed
	if global_position.distance_to(target_position) <= target_radius:
		area2D.monitoring = true

func _on_area_entered(target: Area2D):
	var unit = target.get_parent()
	if unit.data.faction == faction:
		return
	unit.take_damage(20)
	queue_free()
