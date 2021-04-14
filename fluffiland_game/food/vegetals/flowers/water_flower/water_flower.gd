extends StaticBody2D

signal water_earned
signal strength_spend

onready var area_radius = $Area2D/area.shape.radius

onready var pearl_timer = $pearl_generation
onready var sprite = $flower_sprite

onready var produced_indicator = preload("res://popup/produced_spent_indicator/water_produced_indicator.tscn")
onready var used_indicator = preload("res://popup/produced_spent_indicator/strength_used_indicator.tscn")
onready var produced_position = Vector2(30, -120)
onready var used_position = Vector2(-30, -120)

var cost = 2
var health = 180
var health_max = 180
var energy = 100

var nutrient = 2

var specie = "water_flower"# Declare member variables here. Examples:

var pearl_generated = false

var tree_id = str(self.get_instance_id())

func _ready():
	randomize()
	
	self.connect("water_earned", get_tree().root.get_node("Game"), "_on_water_earned")
	self.connect("strength_spend", get_tree().root.get_node("Game"), "_on_strength_spend")
	
	
	pearl_timer.start()
	
	var animation = "closed"
	sprite.play(animation)
	add_to_group ("flower")
	add_to_group ("vegetals")
	add_to_group ("water_flower")
	add_to_group("tree")

	emit_signal("water_earned")
	emit_signal("water_earned")
	var produced = produced_indicator.instance()
	self.add_child(produced)
	produced.position = produced_position
	
	emit_signal("strength_spend")
	var used = used_indicator.instance()
	self.add_child(used)
	used.position = used_position
	
func _process(delta):
	
	if nutrient <= 0 or health <= 0 :
		self.queue_free()

	

func _on_pearl_generation_timeout():
	

	
	pearl_generated = false
	if 	get_tree().root.get_node("Game").strength_count > 0 :
		emit_signal("strength_spend")
		nutrient = 2
		
		var used = used_indicator.instance()
		self.add_child(used)
		used.position = used_position
	
	else :
		nutrient -= 1
	
	
	if nutrient >= 2 :
		var animation = "open"
		sprite.play(animation)
	
	elif nutrient < 2:
		var animation = "open_thirsty"
		sprite.play(animation)
	
	emit_signal("water_earned")
	emit_signal("water_earned")
	var produced = produced_indicator.instance()
	self.add_child(produced)
	produced.position = produced_position
	
	#produced.position.y = self.position.y 
	#pearl_timer.start()	
	



func _on_water_button_pressed():
	

	#else :
	var info_panel_scene = preload ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/info_panel_vegetals_strength.tscn")
	var info_panel = info_panel_scene.instance()
		
	info_panel.specie_text = specie
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.id = tree_id
		
	get_tree().root.get_node("Game/CanvasLayer").add_child(info_panel)
