extends "res://entities/mushroom_baby_base_script.gd"

func _init():


	health = 2
	health_max = 2
	energy = 1
	energy_max = 1

	ressource_generation = 150
	
	specie = "fluffishroom"

	adult_scene = "res://entities/fluffishroom/fluffishroom_adult/fluffishroom.tscn"
