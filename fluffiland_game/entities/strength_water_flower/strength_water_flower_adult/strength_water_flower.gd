extends "res://entities/mushroom_base_script.gd"

func _init():
	
	specie = "strength_water_flower"
	evolution_1 = "big_strength_water_flower"
	evolution_1_text = "equilibrium_path"
	cost_text_1 = 25
	evolution_2 = "water_flower"
	evolution_2_text = "water_path"
	cost_text_2 = 20
	evolution_3 = "strength_flower"
	evolution_3_text = "strength_path"
	cost_text_3 = 20

	health = 3
	health_max = 3

	energy = 6
	energy_max = 6
	
	happiness = 0
	max_happiness = 15

	strength_production = 2
	water_production = 2
	baby_chances = 97
	energy_needed_to_produce = 3
	
	seed_scene = preload("res://entities/strength_water_flower/strength_water_flower_egg/strength_water_flower_egg.tscn")

func _ready():
	var time_left = get_tree().root.get_node("Game/game_start/end_of_day").get_time_left()
	$AnimationPlayer.advance(60 - time_left)
