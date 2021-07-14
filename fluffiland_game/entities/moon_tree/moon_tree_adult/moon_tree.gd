extends "res://entities/plant_base_script.gd"

func _init():
	
	energy = 8
	energy_max = 8
	health = 12
	health_max = 12
	specie = "moon_tree"

	evolution_1 = null
	evolution_1_text = ""
	cost_text_1 = 0

	evolution_2 = null
	evolution_2_text = ""
	cost_text_2 = 0

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0

	happiness = 0
	max_happiness = 120
	bush_capacity = 10
	water_consomption = 3
	reproduction_chances = 98

	bush_scene = load("res://food/moonflower/moonflower.tscn")
	seed_scene = load ("res://entities/moon_tree/moon_tree_egg/moon_tree_egg.tscn")
	
	popup_position = Vector2(0, -100)


