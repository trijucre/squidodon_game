extends "res://entities/mushroom_baby_base_script.gd"

func _init():


	health = 4
	health_max = 4
	energy = 3
	energy_max = 3

	ressource_generation = 250
	
	specie = "big_water_flower"

	adult_scene = "res://entities/big_water_flower/big_water_flower_adult/big_water_flower.tscn"
