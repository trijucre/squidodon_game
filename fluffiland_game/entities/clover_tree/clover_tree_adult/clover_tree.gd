extends "res://entities/plant_base_script.gd"

func _init():
	
	energy = 4
	energy_max = 4
	health = 6
	health_max = 6
	specie = "clover_tree"

	evolution_1 = "big_clover_tree"
	evolution_1_text = "swamp_path"
	cost_text_1 = 50

	evolution_2 = "sun_tree"
	evolution_2_text = "sun_path"
	cost_text_2 = 75

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0

	happiness = 0
	max_happiness = 50
	bush_capacity = 10
	water_consomption = 2
	reproduction_chances = 97

	bush_scene = load("res://food/clover/clover.tscn")
	seed_scene = load ("res://entities/clover_tree/clover_tree_seed/clover_tree_seed.tscn")
	
	popup_position = Vector2(0, -100)
