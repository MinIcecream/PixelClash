@tool
extends Node

@export var battle_data: BattleData
@export var grid: Grid
@export var selected_unit: UnitData
@export var enabled = false
var dirty = false

func _process(_delta: float) -> void:
	if not enabled:
		return
	if not Engine.is_editor_hint():
		return
	if battle_data == null or grid == null:
		return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = grid.get_local_mouse_position()
		var cell = grid.world_to_cell(mouse_pos)
		if cell.x < 0 or cell.y < 0:
			return
		if cell.x >= grid.width or cell.y >= grid.height:
			return

		_place_enemy(cell)

func _place_enemy(cell: Vector2i):
	dirty = true
	battle_data.add_unit(cell, selected_unit)
