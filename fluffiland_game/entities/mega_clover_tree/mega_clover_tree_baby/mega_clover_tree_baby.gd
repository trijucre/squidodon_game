extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 8
	health_max = 8
	energy = 5
	energy_max = 5
	max_happiness = 30
	adulthood = 500

	specie = "mega_clover_tree"

	adult_scene = preload("res://entities/mega_clover_tree/mega_clover_tree_adult/mega_clover_tree.tscn")
