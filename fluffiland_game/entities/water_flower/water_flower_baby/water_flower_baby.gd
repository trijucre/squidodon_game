extends "res://entities/mushroom_baby_base_script.gd"

func _init():


	health = 3
	health_max = 3
	energy = 2
	energy_max = 2
	ressource_generation = 200
	
	specie = "water_flower"

	adult_scene = "res://entities/water_flower/water_flower_adult/water_flower.tscn"
