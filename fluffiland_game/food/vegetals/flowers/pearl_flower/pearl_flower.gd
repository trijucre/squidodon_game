extends StaticBody2D

signal pearl_earned
signal water_spend

onready var pearl_timer = $pearl_generation
onready var sprite = $flower_sprite

onready var area_radius = $Area2D/area.shape.radius

var cost = 4
var health = 180
var health_max = 180
var energy = 100

var nutrient = 2
onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var used_position = Vector2(-30, -120)

var movement

var specie = "pearl_flower"# Declare member variables here. Examples:

var pearl_generated = false

var tree_id = str(self.get_instance_id())

func _ready():
	#move_and_collide()
	randomize()

	self.connect("pearl_earned", get_tree().root.get_node("Game/game_start"), "_on_pearl_earned")
	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
		
	pearl_timer.start()
	
	var animation = "closed"
	sprite.play(animation)
	add_to_group ("flower")
	add_to_group ("vegetals")
	add_to_group ("pearl_flower")
	add_to_group("tree")

func _physics_process(delta):
	
	if health <= 0 :
		self.queue_free()
		
	if nutrient >= 2 and pearl_generated == false :
		var animation = "closed"
		sprite.play(animation)
		
	elif nutrient < 2 and pearl_generated == false :
		var animation = "closed_thirsty"
		sprite.play(animation)

	

func _on_pearl_generation_timeout():
	
	pearl_generated = true

	
	if nutrient >= 2 :
		var animation = "open"
		sprite.play(animation)
	
	elif nutrient < 2 :
		var animation = "open_thirsty"
		sprite.play(animation)
	
	pearl_timer.stop()
	


func _on_pearl_button_pressed():
	
	if pearl_generated == true :
		emit_signal("pearl_earned")
		pearl_generated = false
		var animation = "closed"
		sprite.play(animation)
		
		pearl_timer.start()
		
	else :
		var info_panel_scene = preload ("res://GUI/info_panel_vegetals/info_panel_vegetals_water/info_panel_vegetals.tscn")
		var info_panel = info_panel_scene.instance()
	
		info_panel.specie_text = specie
		info_panel.pv = health
		info_panel.pv_max = health_max
		info_panel.id = tree_id
		
		get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(info_panel)


func _on_health_timeout():
	
	if 	get_tree().root.get_node("Game/game_start").water_count > 0 :
		emit_signal("water_spend")
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
	

