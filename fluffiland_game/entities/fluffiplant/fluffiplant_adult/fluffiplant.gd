extends "res://entities/plant_base_script.gd"

func _init():
	
	energy = 2
	energy_max = 2
	health = 3
	health_max = 3
	specie = "fluffiplant"

	evolution_1 = "tree"
	evolution_1_text = "bush_path"
	cost_text_1 = 25

	evolution_2 = "fruit_tree"
	evolution_2_text = "fruit_path"
	cost_text_2 = 25

	evolution_3 = "clover_tree"
	evolution_3_text = "leaf_path"
	cost_text_3 = 25

	happiness = 0
	max_happiness = 20
	bush_capacity = 5
	water_consomption = 1
	reproduction_chances = 95

	bush_scene = load("res://food/herb/herb.tscn")
	seed_scene = load ("res://entities/fluffiplant/fluffiplant_egg/fluffiplant_egg.tscn")
	
	popup_position = Vector2(0, -20)




