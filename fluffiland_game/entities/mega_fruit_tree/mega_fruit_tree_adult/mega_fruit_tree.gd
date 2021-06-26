extends "res://entities/plant_base_script.gd"

func _init():
	
	energy = 12
	energy_max = 12
	health = 20
	health_max = 20
	specie = "mega_fruit_tree"

	evolution_1 = ""
	evolution_1_text = null
	cost_text_1 = 0

	evolution_2 = ""
	evolution_2_text = null
	cost_text_2 = 0

	evolution_3 = ""
	evolution_3_text = null
	cost_text_3 = 0

	happiness = 0
	max_happiness = 120
	bush_capacity = 15
	water_consomption = 6
	reproduction_chances = 99

	bush_scene = load("res://food/tree_produced_megafruit/tree_produced_megafruit.tscn")
	seed_scene = load ("res://entities/mega_fruit_tree/mega_fruit_tree_egg/mega_fruit_tree_egg.tscn")
	
	popup_position = Vector2(0, -100)

