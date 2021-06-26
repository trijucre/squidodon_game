extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 2
	energy_max = 2
	health = 3
	health_max = 3
	resistance = 1
	specie = "fluffilus"
	attack_damage = 1
	size = 1
	hunger = 1

	evolution_1 = "cuttlepig"
	evolution_1_text = "tentacles_path"
	cost_text_1 = 25

	evolution_2 = "amoneep"
	evolution_2_text = "shell_path"
	cost_text_2 = 25

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "herbivore"
	happiness = 0
	max_happiness = 30

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "herb"
	eat_2 = "herb"

	speed = 50
	run_speed = 50
	look_ahead = 600
	num_rays = 12
	
	attack_distance = 50
	baby_incubation = 540
	
	energy_spent = 1
	egg_number = 1
	
	meat_scene = preload("res://food/meat/Squid_meat/squid_meat.tscn")
	egg_scene = preload("res://entities/fluffilus/fluffilus_egg/fluffilus_egg.tscn")
	poop_scene = preload("res://food/poop/poop.tscn")
func _ready():
	add_to_group("creature", true)
	add_to_group("prey", true)
	
	if sleep_hour == null :
		sleep_hour = 10 + randi()% 10 + 1
	if wake_hour == null :
		wake_hour = 60 - (randi()% 10 + 1)


