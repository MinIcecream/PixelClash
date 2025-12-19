extends Resource
class_name UnitData

enum Faction { PLAYER, ENEMY }

@export var faction: Faction = Faction.PLAYER
@export var speed: float = 100
@export var attack_range: float = 30
@export var attack_cooldown: float = 1.0
@export var damage: int = 10
@export var health: int = 20
@export var size: Vector2 = Vector2(1, 1)
@export var target_groups: Array[String]
