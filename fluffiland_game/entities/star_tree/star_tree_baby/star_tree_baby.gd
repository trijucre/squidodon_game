extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 5
	health_max = 5
	energy = 3
	energy_max = 3
	max_happiness = 20
	adulthood = 385

	specie = "star_tree"

	adult_scene = preload("res://entities/star_tree/star_tree_adult/star_tree.tscn")
