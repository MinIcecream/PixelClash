extends Node

func get_target(groups: Array[String]) -> Node:
	return get_closest_target(groups)

func get_closest_target(groups: Array[String]) -> Node:
	var closest = null
	var min_dist2 = INF
	var target_nodes = []
	
	for group in groups:
		var group_nodes = get_tree().get_nodes_in_group((group))
		target_nodes.append_array((group_nodes))

	for target in target_nodes:
		var dist2 = self.global_position.distance_to(target.global_position)
		
		if dist2 < min_dist2:
			min_dist2 = dist2
			closest = target
	return closest
