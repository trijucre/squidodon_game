extends StaticBody2D

signal water_spend
signal diversity_level_1_enter
signal pearl_earned

onready var area_radius = $Area2D/area.shape.radius

var save_value = "Persist_child"

var bush_time =0
var health_time =0

var saved = false

var cost = 0
var energy = 200
var energy_max = 200
var health = 200
var health_max = 200
var specie = "pond"
var nutrient = 4
var nutrient_max = 4
onready var used_position = Vector2(-30, -600)

var pond_id = str(self.get_instance_id())
onready var sprite = $Sprite
onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var default = preload("res://constructs/pond/sprite/pond_sprite.png")
onready var thirsty = preload ("res://constructs/pond/sprite/pond_sprite_thirsty.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.connect("diversity_level_1_enter", get_tree().root.get_node("Game/game_start"), "_on_diversity_level_1_enter")
	self.connect("diversity_level_1_out", get_tree().root.get_node("Game/game_start"), "_on_diversity_level_1_out")
	self.connect("pearl_earned", get_tree().root.get_node("Game/game_start"), "_on_pearl_earned")
	
	randomize()
	
	add_to_group("construct")
	add_to_group("pond")

	add_to_group("Persist", true)
	add_to_group("persist_child", true)

	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	if saved == false :
		emit_signal("pearl_earned")
	emit_signal("diversity_level_1_enter")
	
	saved = true
func _on_Timer_timeout():

	health_time += 1
	if health_time >= 60 :
		
		nutrient -= 1
		
		if 	get_tree().root.get_node("Game/game_start").water_count >= 1 :

			if nutrient < nutrient_max :
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
			emit_signal("diversity_level_1_out")
			
		health_time =0




func _on_info_panel_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/info_panel_vegetals_strength.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.nutrient = nutrient
	info_panel.nutrient_max = nutrient_max
	info_panel.id = pond_id

	get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(info_panel)

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"nutrient" : nutrient,
		"health_time" : health_time,
		"saved" : saved
	}
	return save
