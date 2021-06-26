extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 4
	health_max = 4
	energy = 2
	energy_max = 2
	max_happiness = 15
	adulthood = 310

	specie = "clover_tree"

	adult_scene = preload("res://entities/clover_tree/clover_tree_adult/clover_tree.tscn")
