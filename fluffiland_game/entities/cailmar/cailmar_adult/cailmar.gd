extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 6
	energy_max = 6
	health = 5
	health_max = 5
	resistance = 3
	attack_damage = 4
	specie = "cailmar"
	size = 3
	hunger = 3

	evolution_1 = "octogator"
	evolution_1_text = "Jaw path"
	cost_text_1 = 40

	evolution_2 = "dimetroctopus"
	evolution_2_text = "Spine path"
	cost_text_2 = 40

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "hunter"
	happiness = 0
	max_happiness = 80

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "meat"
	eat_2 = "meat"

	speed = 50
	run_speed = 70
	look_ahead = 1200
	num_rays = 24
	
	attack_distance = 100
	baby_incubation = 610
	
	energy_spent = 1
	egg_number = 1
	
	meat_scene = preload("res://food/meat/Squid_meat/squid_meat.tscn")
	egg_scene = preload("res://entities/amoneep/amoneep_egg/amoneep_egg.tscn")
	poop_scene = preload("res://food/poop/poop.tscn")
func _ready():
	add_to_group("creature", true)
	add_to_group("predator", true)
	add_to_group("prey", true)
	
	if sleep_hour == null :
		sleep_hour = 10 + randi()% 10 + 1
	if wake_hour == null :
		wake_hour = 60 - (randi()% 10 + 1)
