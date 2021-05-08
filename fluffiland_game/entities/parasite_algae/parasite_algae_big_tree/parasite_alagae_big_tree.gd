extends StaticBody2D

signal water_spend

var health = 100
var health_max = 100
var energy = 50
var energy_max = 50

var reproduce_time = 0
var reproduce_chance = 0
var reproduce_number
onready var reproduction_scene = preload("res://entities/parasite_algae/parasit_algae_sprout/parasite_alagae_sprout.tscn")

var center_x = self.position.x - 250
var center_y = self.position.y - 250
var spawn_area : Rect2 = Rect2(center_x, center_y, 500, 500)
var rngx
var rngy

func _ready():
	randomize()
	add_to_group("parasite_algae")
	
	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	
	rngx = RandomNumberGenerator.new()
	rngy = RandomNumberGenerator.new()
	
func creature_reproduction():
	
	rngx.randomize()
	rngy.randomize()
	var reproduction = reproduction_scene.instance()

	get_tree().root.get_node("Game/game_start/YSort").add_child(reproduction)

	reproduction.position.x = center_x + rngx.randf_range(0, spawn_area.size.x)
	reproduction.position.y = center_y + rngy.randf_range(0, spawn_area.size.x)
	
func _on_Timer_timeout():
	if get_tree().root.get_node("Game/game_start").water_count > 10 :
		emit_signal("water_spend", 10)
	
	reproduce_time += 1
	if reproduce_time >= 60 :
		reproduce_chance += 1
		if reproduce_chance >= reproduce_number :
			creature_reproduction()
		reproduce_time = 0
		 
