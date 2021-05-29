extends StaticBody2D

signal water_spend

var health = 20
var health_max = 20
var energy = 20
var energy_max = 20

var save_value = "Persist_child"
var sleep_hour

var evolve_time = 0
var evolution_chance = 0
var evolution_number
var evolution_choice
onready var evolution_scene_plant = preload("res://entities/parasite_algae/parasite_algae_plant/parasite_alagae_plant.tscn")
onready var evolution_scene_animal = preload ("res://entities/parasite_algae/parasite_algae_walker/parasit_algae_walker.tscn")
var evolution_scene

onready var area_radius = $Area2D/area.shape.radius

func _ready():
	randomize()
	add_to_group("parasite_algae")
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	
	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	
	sleep_hour = 0.7 + (randf() * 0.2 + 0.05)
	
	evolution_choice  = randi()% 10 + 1
	
	evolution_number = randi()% 100 + 1


func creature_evolution():
	
	if evolution_choice == 10 :
		evolution_scene = evolution_scene_animal
	else :
		evolution_scene = evolution_scene_plant
	var evolution = evolution_scene.instance()
	get_parent().add_child(evolution)
	evolution.position = self.position
	self.queue_free()

func _on_Timer_timeout():
	
	
	evolve_time += 1
	if evolve_time >= 60 :
		
		if get_tree().root.get_node("Game/game_start").water_count > 1 :
			emit_signal("water_spend", 1)
		
		evolution_chance += 1
		if evolution_chance >= evolution_number :
			creature_evolution()
		evolve_time = 0

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value,
		"evolve_time" : evolve_time,
		"sleep_hour" : sleep_hour
	}
	return save
