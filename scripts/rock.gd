extends Projectile

@onready var area2D = $"Area2D"
@export var lifeTime = 10
@export var target_radius = 4
@export var speed = 240

func _ready() -> void:
	area2D.area_entered.connect(Callable(self, "_on_area_entered"))
	await get_tree().create_timer(lifeTime).timeout
	queue_free()

func _physics_process(delta: float) -> void:	
	var dir = (target_position - self.global_position).normalized()
	var distance_to_target = global_position.distance_to(target_position)
	var move_distance = delta * speed
	
	# if next move would overshoot target, clamp it.
	if move_distance >= distance_to_target:
		global_position = target_position
		deal_damage()

	rotation = dir.angle() + deg_to_rad(90)
	global_position += dir * delta * speed


func deal_damage() -> void:
	var targets = area2D.get_overlapping_areas()
	for unit in targets:
		if unit.faction == faction:
			continue
		unit.take_damage(damage)
		var dir = (unit.global_position - global_position).normalized()
		var knockback = Knockback.new(dir * 1300)
		unit.knockback(knockback)
	queue_free()
