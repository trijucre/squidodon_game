extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 8
	health_max = 8
	energy = 5
	energy_max = 5
	max_happiness = 30
	adulthood = 500

	specie = "mega_bush_tree"

	adult_scene = preload("res://entities/mega_bush_tree/mega_bush_tree_adult/mega_bush_tree.tscn")
