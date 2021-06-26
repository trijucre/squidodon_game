extends "res://entities/mushroom_base_script.gd"

func _init():
	
	specie = "_strength_water_flower"
	evolution_1 = "mega_strength_water_flower"
	evolution_1_text = "spiritual_path"
	cost_text_1 = 35
	evolution_2 = null
	evolution_2_text = ""
	cost_text_2 = 0
	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0

	health = 5
	health_max = 5

	energy = 15
	energy_max = 15
	
	happiness = 0
	max_happiness = 35

	strength_production = 3
	water_production = 3
	baby_chances = 98
	energy_needed_to_produce = 5
	
	seed_scene = preload("res://entities/big_water_flower/big_water_flower_egg/big_water_flower_egg.tscn")
