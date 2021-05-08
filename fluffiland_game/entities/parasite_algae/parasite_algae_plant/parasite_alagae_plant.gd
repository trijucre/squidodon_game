extends StaticBody2D

signal water_spend

var health = 30
var health_max = 30
var energy = 20
var energy_max = 20

var evolve_time = 0
var evolution_chance = 0
var evolution_number
var evolution_choice
onready var evolution_scene = null#preload("")


func _ready():
	randomize()
	add_to_group("parasite_algae")
	
	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	
	evolution_number = randi()% 100 + 1


func creature_evolution():
	

	var evolution = evolution_scene.instance()
	get_parent().add_child(evolution)
	evolution.position = self.position
	self.queue_free()

func _on_Timer_timeout():
	if get_tree().root.get_node("Game/game_start").water_count > 5 :
		emit_signal("water_spend", 5)
	
	evolve_time += 1
	if evolve_time >= 60 :
		evolution_chance += 1
		if evolution_chance >= evolution_number :
			creature_evolution()
		evolve_time = 0
		 
