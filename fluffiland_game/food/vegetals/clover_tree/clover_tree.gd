extends StaticBody2D

signal water_spend

var cost = 8
var energy = 200
var energy_max = 200
var health = 200
var health_max = 200
var specie = "clover_tree"
var nutrient = 4
var nutrient_max = 4
onready var used_position = Vector2(-30, -1000)

onready var area_radius = $Area2D/area.shape.radius

var bush_scene = preload("res://food/vegetals/clover_tree/tree_produced-clover/tree_produced_clover.tscn")
onready var sprite = $Sprite

var center_x = self.position.x - 125
var center_y = self.position.y - 125
var spawn_area : Rect2 = Rect2(center_x, center_y, 250, 250)

var tree_id = str(self.get_instance_id())
var rngx = RandomNumberGenerator.new()
var rngy = RandomNumberGenerator.new()

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var default = preload("res://food/vegetals/tree/sprites/tree.png")
onready var thirsty = preload ("res://food/vegetals/tree/sprites/tree_thirsty.png")
var bush_produced = 0
# Called when the node enters the scene tree for the first time.
func _ready():

	randomize()
	
	add_to_group("clover_tree")
	add_to_group("vegetals")
	add_to_group("tree")
	self.connect("water_spend", get_tree().root.get_node("Game"), "_on_water_spend")
	
	
func _on_bush_timer_timeout():
	
	bush_produced = get_tree().get_nodes_in_group(tree_id).size()

	if bush_produced <= 10 :
		rngx.randomize()
		rngy.randomize()
		var tree_bush = bush_scene.instance()
		tree_bush.id = tree_id
		get_tree().root.get_node("Game/YSort").add_child(tree_bush)

		tree_bush.position.x = self.position.x - 125 + rngx.randf_range(0, spawn_area.size.x)
		tree_bush.position.y = self.position.y - 125 + rngy.randf_range(0, spawn_area.size.x)

	else : 
		pass
	


func _on_health_timeout():
	if 	get_tree().root.get_node("Game").water_count > 1 :
		emit_signal("water_spend")
		emit_signal("water_spend")
		nutrient += 2
		
		if nutrient > nutrient_max :
			nutrient = nutrient_max
		
		var used = used_indicator.instance()
		self.add_child(used)
		used.position = used_position
		
	elif 	get_tree().root.get_node("Game").water_count == 1 :
		emit_signal("water_spend")
		nutrient += 1
		if nutrient > nutrient_max :
			nutrient = nutrient_max
	
		var used = used_indicator.instance()
		self.add_child(used)
		used.position = used_position
	
	else :
		nutrient -= 1
		
	if nutrient > 2 :
		var animation = "default"
		sprite.play(animation)
	elif nutrient > 0 :
		var animation = "thirsty"
		sprite.play(animation)
		
	elif nutrient <= 0 :
		self.queue_free()
		
	
	
func _on_bush_produced():
	bush_produced +=1


func _on_info_panel_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel_vegetals/info_panel_vegetals_water/info_panel_vegetals.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.id = tree_id

	get_tree().root.get_node("Game/CanvasLayer").add_child(info_panel)
