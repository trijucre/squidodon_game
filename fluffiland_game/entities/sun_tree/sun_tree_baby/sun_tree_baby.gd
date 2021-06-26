extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 5
	health_max = 5
	energy = 3
	energy_max = 3
	max_happiness = 20
	adulthood = 385

	specie = "sun_tree"

	adult_scene = preload("res://entities/sun_tree/sun_tree_adult/sun_tree.tscn")
