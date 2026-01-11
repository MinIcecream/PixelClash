@tool
extends Node

var ghost_units: Array = []
@export var grid: Grid

func _process(_delta: float) -> void:
	if get_parent().dirty:
		get_parent().dirty = false
		refresh_ghosts()

func refresh_ghosts():
	for ghost in ghost_units:
		ghost.queue_free()
	ghost_units.clear()
	var battle_data = get_parent().battle_data
		# Draw new ghosts
	if not battle_data:
		return
	for position in battle_data.enemy_units:
		print(battle_data.enemy_units[position].name)
		print(UnitRegistry.units)
		var unit = UnitRegistry.units[battle_data.enemy_units[position].name]
		var ghost = unit.scene.instantiate()
		ghost.modulate = Color(1,1,1,0.5)
		ghost.position = grid.world_pos_to_spawn_unit(position, unit.data)
		add_child(ghost)
		ghost_units.append(ghost)
