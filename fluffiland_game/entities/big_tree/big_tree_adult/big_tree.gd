extends "res://entities/plant_base_script.gd"

func _init():
	
	energy = 12
	energy_max = 12
	health = 8
	health_max = 8
	specie = "big_tree"

	evolution_1 = "mega_bush_tree"
	evolution_1_text = "forest_path"
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

	bush_scene = load("res://food/bigbush/bigbush.tscn")
	seed_scene = load ("res://entities/big_tree/big_tree_egg/big_tree_egg.tscn")
	
	popup_position = Vector2(0, -100)

func _ready():
	add_to_group("tree",true)
	add_to_group("vegetals",true)
	add_to_group("big_clover_tree",true)
	add_to_group("creature", true)


