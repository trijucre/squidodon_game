extends "res://entities/plant_base_script.gd"

func _init():
	
	energy = 8
	energy_max = 8
	health = 12
	health_max = 12
	specie = "big_fruit_tree"

	evolution_1 = "mega_fruit_tree"
	evolution_1_text = "vine_path"
	cost_text_1 = 100

	evolution_2 = null
	evolution_2_text = ""
	cost_text_2 = 0

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0

	happiness = 0
	max_happiness = 120
	bush_capacity = 10
	water_consomption = 4
	reproduction_chances = 98

	bush_scene = load("res://food/bigfruit/bigfruit.tscn")
	seed_scene = load ("res://entities/big_fruit_tree/big_fruit_tree_egg/big_fruit_tree_tree_egg.tscn")
	
	popup_position = Vector2(0, -100)

func _ready():
	add_to_group("tree",true)
	add_to_group("vegetals",true)
	add_to_group("big_fruit_tree",true)
	add_to_group("creature", true)

