extends "res://entities/plant_baby_base_script.gd"


func _init():
	
	health = 3
	health_max = 3
	energy = 1
	energy_max = 1
	max_happiness = 10
	adulthood = 240

	specie = "fluffiplant"

	adult_scene = preload("res://entities/fluffiplant/fluffiplant_adult/fluffiplant.tscn")

