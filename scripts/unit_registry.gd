@tool

extends Node

var units := {
	"swordsman": {
		"scene": preload("res://scenes/swordsman.tscn"),
		"data": preload("res://data/units/swordsman.tres")
	},
	"archer": {
		"scene": preload("res://scenes/archer.tscn"),
		"data": preload("res://data/units/archer.tres")
	},
	"knight": {
		"scene": preload("res://scenes/knight.tscn"),
		"data": preload("res://data/units/knight.tres")
	},
	"calvalry": {
		"scene": preload("res://scenes/calvalry.tscn"),
		"data": preload("res://data/units/calvalry.tres")
	},
	"alchemist": {
		"scene": preload("res://scenes/alchemist.tscn"),
		"data": preload("res://data/units/alchemist.tres")
	},
	"enemy": {
		"scene": preload("res://scenes/enemy.tscn"),
		"data": preload("res://data/units/enemy_test.tres")
	},
	"troll": {
		"scene": preload("res://scenes/troll.tscn"),
		"data": preload("res://data/units/troll.tres")
	}
}
