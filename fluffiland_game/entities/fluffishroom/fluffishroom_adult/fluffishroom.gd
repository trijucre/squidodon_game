extends "res://entities/mushroom_base_script.gd"

func _init():
	
	specie = "fluffishroom"
	evolution_1 = "water_flower"
	evolution_1_text = "water_path"
	cost_text_1 = 10
	evolution_2 = "strength_flower"
	evolution_2_text = "strength_path"
	cost_text_2 = 10
	evolution_3 = "strength_water_flower"
	evolution_3_text = "balance_path"
	cost_text_3 = 12

	health = 2
	health_max = 2

	energy = 3
	energy_max = 3
	
	happiness = 0
	max_happiness = 10

	strength_production = 1
	water_production = 1
	baby_chances = 95
	energy_needed_to_produce = 1
	
	seed_scene = preload("res://entities/fluffishroom/fluffishroom_egg/fluffishroom_egg.tscn")
