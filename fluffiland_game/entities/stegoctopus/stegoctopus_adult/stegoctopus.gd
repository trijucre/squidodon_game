extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 11
	energy_max = 11
	health = 11
	health_max = 11
	resistance = 10
	attack_damage = 3
	specie = "stegoctopus"
	size = 5
	hunger = 9

	evolution_1 = null
	evolution_1_text = ""
	cost_text_1 = 0

	evolution_2 = null
	evolution_2_text = ""
	cost_text_2 = 0

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "herbivore"
	happiness = 0
	max_happiness = 120

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "clover"
	eat_2 = "fruit"

	speed = 20
	run_speed = 20
	look_ahead = 600
	num_rays = 12
	
	attack_distance = 100
	baby_incubation = 610
	
	energy_spent = 1
	egg_number = 1
	
	meat_scene = preload("res://food/meat/Squid_meat/squid_meat.tscn")
	egg_scene = preload("res://entities/amoneep/amoneep_egg/amoneep_egg.tscn")
	poop_scene = preload("res://food/poop/poop.tscn")
func _ready():
	add_to_group("creature", true)
	add_to_group("prey", true)
	
	if sleep_hour == null :
		sleep_hour = 10 + randi()% 10 + 1
	if wake_hour == null :
		wake_hour = 60 - (randi()% 10 + 1)

