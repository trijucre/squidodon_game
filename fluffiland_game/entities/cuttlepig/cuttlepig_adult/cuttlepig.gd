extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 4
	energy_max = 4
	health = 4
	health_max = 4
	resistance = 2
	attack_damage = 2
	specie = "cuttlepig"
	size = 2
	hunger = 2

	evolution_1 = "cowctopus"
	evolution_1_text = "horn_path"
	cost_text_1 = 40

	evolution_2 = "cuttleboar"
	evolution_2_text = "tusk_path"
	cost_text_2 = 40

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "herbivore"
	happiness = 0
	max_happiness = 30

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "fruit"
	eat_2 = "meat"

	speed = 60
	run_speed = 60
	look_ahead = 600
	num_rays = 12
	
	attack_distance = 60
	baby_incubation = 700
	
	energy_spent = 1
	egg_number = 1
	
	meat_scene = preload("res://food/meat/Squid_meat/squid_meat.tscn")
	egg_scene = preload("res://entities/cuttlepig/fluffilus_egg/cuttlepig_egg.tscn")
	poop_scene = preload("res://food/poop/poop.tscn")
func _ready():
	
	add_to_group("creature", true)
	add_to_group("prey", true)
	
	if sleep_hour == null :
		sleep_hour = 10 + randi()% 10 + 1
	if wake_hour == null :
		wake_hour = 60 - (randi()% 10 + 1)


