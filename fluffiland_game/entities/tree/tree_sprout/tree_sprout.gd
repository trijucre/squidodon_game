extends StaticBody2D

signal water_spend

onready var area_radius = $Area2D/area.shape.radius

var save_value = "Persist_child"


var health_time =0

var adulthood = 0
onready var adult_scene = preload ("res://food/vegetals/tree/tree.tscn")

var cost = 1
var energy = 200
var energy_max = 200
var health = 200
var health_max = 200
var specie = "tree"
var nutrient = 4
var nutrient_max = 4
onready var used_position = Vector2(-30, -200)



onready var sprite = $Sprite

var center_x = self.position.x - 125
var center_y = self.position.y - 125


var tree_id = str(self.get_instance_id())
var rngx = RandomNumberGenerator.new()
var rngy = RandomNumberGenerator.new()

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var default = preload("res://food/vegetals/tree/tree_sprout/tree_sprout.png")
onready var thirsty = preload ("res://food/vegetals/tree/tree_sprout/tree_sprout_thirsty.png")
var bush_produced = 0
# Called when the node enters the scene tree for the first time.
func _ready():

	randomize()
	
	add_to_group("tree")
	add_to_group("vegetals")

	add_to_group("Persist", true)
	add_to_group("persist_child", true)

	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	
	
func _on_Timer_timeout():
	adulthood += 1
	health_time += 1
	
	if adulthood >= 300 :
		var adult = adult_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(adult)
		adult.position = self.position
		$Timer.stop()
		self.queue_free()
	if health_time >= 60 :
		nutrient -= 1
		
		if 	get_tree().root.get_node("Game/game_start").water_count >= 1 :
			emit_signal("water_spend")
			nutrient += 1
			if nutrient > nutrient_max :
				nutrient = nutrient_max
			
			var used = used_indicator.instance()
			self.add_child(used)
			used.position = used_position
			

				
		if nutrient > 2 :
			var animation = "default"
			sprite.play(animation)
		elif nutrient > 0 :
			var animation = "thirsty"
			sprite.play(animation)
				
		elif nutrient <= 0 :
			self.queue_free()
			
		health_time =0

	
func _on_bush_produced():
	bush_produced +=1


func _on_info_panel_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/info_panel_vegetals_strength.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.nutrient = nutrient
	info_panel.nutrient_max = nutrient_max
	info_panel.id = tree_id

	get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(info_panel)

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"nutrient" : nutrient,
		"adulthood" : adulthood,
		"health_time" : health_time,
	}
	return save
