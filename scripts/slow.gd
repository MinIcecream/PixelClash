extends MovementVelocityModifierCC
class_name Slow

var slow_amount: float
var end_time: float

func _init(_slow_amount, _slow_duration) -> void:
	slow_amount = _slow_amount
	end_time = _slow_duration + UnpausedTime.now

# 0.2 means 20% reduced speed. I.e., 80% of the unit's normal speed
func get_velocity_modifier() -> float:
	return slow_amount

func is_completed() -> bool:
	return UnpausedTime.now >= end_time
