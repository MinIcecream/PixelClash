extends AdditiveCC
class_name Knockback

var initial_velocity: Vector2
var applied = false

func _init(_initial_velocity: Vector2) -> void:
	initial_velocity = _initial_velocity

func get_velocity() -> Vector2:
	applied = true
	return initial_velocity

func is_completed() -> bool:
	if applied:
		return true
	return false
