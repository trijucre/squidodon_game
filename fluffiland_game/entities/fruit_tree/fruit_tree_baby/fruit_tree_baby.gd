extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 4
	health_max = 4
	energy = 2
	energy_max = 2
	max_happiness = 15
	adulthood = 310

	specie = "fruit_tree"

	adult_scene = preload("res://entities/fruit_tree/fruit_tree_adult/fruit_tree.tscn")
