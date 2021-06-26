extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 6
	energy_max = 6
	health = 8
	health_max = 8
	resistance = 2
	attack_damage = 3
	specie = "cowctopus"
	size = 3
	hunger = 5

	evolution_1 = "buffalopod"
	evolution_1_text = "horn path"
	cost_text_1 = 80

	evolution_2 = "octaiga"
	evolution_2_text = "leg path"
	cost_text_2 = 80

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "herbivore"
	happiness = 0
	max_happiness = 80

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "bush"
	eat_2 = "bush"

	speed = 70
	run_speed = 70
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

