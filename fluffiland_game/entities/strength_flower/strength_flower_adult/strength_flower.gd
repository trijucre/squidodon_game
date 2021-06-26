extends "res://entities/mushroom_base_script.gd"

func _init():
	
	specie = "strength_flower"
	evolution_1 = "big_strength_flower"
	evolution_1_text = "materialism_path"
	cost_text_1 = 20
	evolution_2 = "strength_water_flower"
	evolution_2_text = "resilience_path"
	cost_text_2 = 18
	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0

	health = 3
	health_max = 3

	energy = 10
	energy_max = 10
	
	happiness = 0
	max_happiness = 15

	strength_production = 3
	water_production = 0
	baby_chances = 97
	energy_needed_to_produce = 3
	
	seed_scene = preload("res://entities/strength_flower/strength_flower_egg/strength_flower_egg.tscn")
