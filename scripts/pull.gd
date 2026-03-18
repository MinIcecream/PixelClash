extends AdditiveCC
class_name Pull

var pull_velocity: Vector2
var end_time: float

func _init(_pull_velocity: Vector2, _duration: float) -> void:
	pull_velocity = _pull_velocity
	end_time = UnpausedTime.now + _duration

func get_velocity() -> Vector2:
	return pull_velocity

func is_completed() -> bool:
	return UnpausedTime.now >= end_time
