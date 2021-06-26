extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 5
	health_max = 5
	energy = 3
	energy_max = 3
	max_happiness = 20
	adulthood = 385

	specie = "big_clover_tree"

	adult_scene = preload("res://entities/big_clover_tree/big_clover_tree_adult/big_clover_tree.tscn")
