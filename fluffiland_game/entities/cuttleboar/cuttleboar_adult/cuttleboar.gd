extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 8
	energy_max = 8
	health = 5
	health_max = 5
	resistance = 2
	attack_damage = 4
	specie = "cuttleboar"
	size = 3
	hunger = 6

	evolution_1 = "calmazorback"
	evolution_1_text = "tusk path"
	cost_text_1 = 30

	evolution_2 = "canipod"
	evolution_2_text = "claw path"
	cost_text_2 = 30

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "herbivore"
	happiness = 0
	max_happiness = 80

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "fruit"
	eat_2 = "meat"

	speed = 60
	run_speed = 60
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

