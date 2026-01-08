extends MovementVelocityModifierCC
class_name Stagger

var end_time: float

func _init(_duration: float) -> void:
	end_time = UnpausedTime.now + _duration

# 0.2 means 20% reduced speed. I.e., 80% of the unit's normal speed
func get_velocity_modifier() -> float:
	return 0

func is_completed() -> bool:
	return UnpausedTime.now >= end_time