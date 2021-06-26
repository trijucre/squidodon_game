extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 8
	energy_max = 8
	health = 6
	health_max = 6
	resistance = 2
	attack_damage = 5
	specie = "canipod"
	size = 4
	hunger = 5

	evolution_1 = "octiger"
	evolution_1_text = "rayure path"
	cost_text_1 = 100

	evolution_2 = "smiloctopus"
	evolution_2_text = "canine path"
	cost_text_2 = 100

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "hunter"
	happiness = 0
	max_happiness = 80

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "meat"
	eat_2 = ""

	speed = 60
	run_speed = 80
	look_ahead = 1000
	num_rays = 18
	
	attack_distance = 100
	baby_incubation = 610
	
	energy_spent = 3
	egg_number = 1
	
	meat_scene = preload("res://food/meat/Squid_meat/squid_meat.tscn")
	egg_scene = preload("res://entities/amoneep/amoneep_egg/amoneep_egg.tscn")
	poop_scene = preload("res://food/poop/poop.tscn")
	
func _ready():
	add_to_group("creature", true)
	add_to_group("predator", true)
	
	if sleep_hour == null :
		sleep_hour = 10 + randi()% 10 + 1
	if wake_hour == null :
		wake_hour = 60 - (randi()% 10 + 1)

