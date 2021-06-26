extends "res://entities/mushroom_base_script.gd"

func _init():
	
	specie = "mega_strength_water_flower"
	evolution_1 = null
	evolution_1_text = ""
	cost_text_1 = 0
	evolution_2 = null
	evolution_2_text = ""
	cost_text_2 = 0
	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0

	health = 10
	health_max = 10

	energy = 20
	energy_max = 20
	
	happiness = 0
	max_happiness = 50

	strength_production = 10
	water_production = 0
	baby_chances = 99
	energy_needed_to_produce = 10
	
	seed_scene = preload("res://entities/mega_strength_water_flower/mega_strength_water_flower_egg/mega_strength_water_flower_egg.tscn")
