extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 5
	health_max = 5
	energy = 3
	energy_max = 3
	max_happiness = 20
	adulthood = 385

	specie = "moon_tree"

	adult_scene = preload("res://entities/moon_tree/moon_tree_adult/moon_tree.tscn")
