extends Node

var units := {
	"swordsman": {
		"scene": preload("res://scenes/swordsman.tscn"),
		"data": preload("res://data/swordsman.tres")
	},
	"archer": {
		"scene": preload("res://scenes/archer.tscn"),
		"data": preload("res://data/archer.tres")
	},
	"enemy": {
		"scene": preload("res://scenes/enemy.tscn"),
		"data": preload("res://data/enemy_test.tres")
	}
}
