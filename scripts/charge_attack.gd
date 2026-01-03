extends Attack

@onready var area2D = $"Area2D"

var hit_units := {}
var chargeDirection = null

func _ready() -> void:
	area2D.area_entered.connect(Callable(self, "_on_area_entered"))

func _on_area_entered(unit: Area2D) -> void:
	if unit in hit_units or unit.faction == self.get_parent().data.faction:
		return

	unit.take_damage(self.get_parent().data.damage)
	hit_units[unit] = true
	_apply_hit_effects(unit)

func _apply_hit_effects(unit: Area2D) -> void:
	var forward = (unit.global_position - global_position).normalized()
	var side = Vector2(-forward.y, forward.x)

	# Randomly choose left or right
	if randf() < 0.5:
		side = -side

	# Mix sideways + a bit of forward
	var knock_dir = (side * 0.8 + forward * 0.2).normalized()

	unit.knockback(str(self), knock_dir * 2000)


func _do_attack(target: Node2D) -> void:
	var dir = target.global_position - self.global_position
	area2D.rotation = dir.angle()

	await get_tree().create_timer(0.5).timeout
	enable_hitbox()
	chargeDirection = dir.normalized()
	await get_tree().create_timer(0.75).timeout
	disable_hitbox()
	chargeDirection = null
	await get_tree().create_timer(1).timeout
	finish_attack()

func enable_hitbox():
	area2D.monitoring = true
	hit_units = {}

func disable_hitbox():
	area2D.monitoring = false

func _physics_process(delta: float) -> void:
	if chargeDirection != null:
		var desired = chargeDirection * get_parent().data.speed * 5
		get_parent().velocity = desired
		get_parent().move_and_slide()
		
