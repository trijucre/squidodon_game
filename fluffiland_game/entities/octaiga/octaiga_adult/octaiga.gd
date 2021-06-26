extends "res://entities/animal_base_script.gd"

func _init():
	
	energy = 6
	energy_max = 6
	health = 6
	health_max = 6
	resistance = 1
	attack_damage = 2
	specie = "octaiga"
	size = 4
	hunger = 5

	evolution_1 = "moosopod"
	evolution_1_text = "antler path"
	cost_text_1 = 100

	evolution_2 = "squiraffe"
	evolution_2_text = "neck path"
	cost_text_2 = 100

	evolution_3 = null
	evolution_3_text = ""
	cost_text_3 = 0
	
	food_chain_position = "herbivore"
	happiness = 0
	max_happiness = 80

	produce_1 = "poop"
	produce_2 = null
	eat_1 = "fruit"
	eat_2 = "bush"

	speed = 80
	run_speed = 100
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

