extends Node

var units := {
	"player": {
		"scene": preload("res://scenes/knight.tscn"),
		"data": preload("res://data/player_test.tres")
	},
	"enemy": {
		"scene": preload("res://scenes/enemy.tscn"),
		"data": preload("res://data/enemy_test.tres")
	}
}
