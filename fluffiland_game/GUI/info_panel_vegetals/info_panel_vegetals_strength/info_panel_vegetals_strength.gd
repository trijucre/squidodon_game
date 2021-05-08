extends Node2D

var specie_text 
var nutrient
var nutrient_max
var id

signal tree_energized

onready var water_texture = load("res://GUI/info_panel_vegetals/info_panel_vegetals_water/info_panel_vegetals_water_full.png")
onready var evolution_panel_scene = preload("res://GUI/evolution_panel/evolution_panel.tscn")

onready var specie_name = $info_panel_text/specie_name

onready var water_indicator_1 = $VBoxContainer/water_container_1
onready var water_indicator_2 = $VBoxContainer/water_container_2
onready var water_indicator_3 = $VBoxContainer/water_container_3
onready var water_indicator_4 = $VBoxContainer/water_container_4
onready var water_indicator_5 = $VBoxContainer/water_container_5
onready var water_indicator_6 = $VBoxContainer/water_container_6

var number_of_nutrient

#onready var water_logo = get_node("VBoxContainer/water_container_" + str(number_of_nutrient) + "/water_indicator_" + str(number_of_nutrient))


#onready var water_1 = $VBoxContainer/water_container_1/water_indicator_1
#onready var water_2 = $VBoxContainer/water_container_2/water_indicator_2
#onready var water_3 = $VBoxContainer/water_container_3/water_indicator_3
#onready var water_4 = $VBoxContainer/water_container_4/water_indicator_4
#onready var water_5 = $VBoxContainer/water_container_5/water_indicator_5
#onready var water_6 = $VBoxContainer/water_container_6/water_indicator_6


# Called when the node enters the scene tree for the first time.
func _ready():

	for node in get_tree().get_nodes_in_group("info_panel") :
		node.queue_free()
	
	add_to_group("info_panel")
	
	self.position = Vector2(1400, 70)
	
	self.connect("tree_energized", get_tree().root.get_node("Game/game_start"), "_on_tree_energized")
	
	set_water_container()
	
	set_remaining_water()
		

		
	specie_name.text = str (specie_text)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_water_container():
	if nutrient_max == 5 :
		water_indicator_6.queue_free()
	
	elif nutrient_max == 4 :
		water_indicator_6.queue_free()
		water_indicator_5.queue_free()
	
	elif nutrient_max  == 3 :
		water_indicator_6.queue_free()
		water_indicator_5.queue_free()
		water_indicator_4.queue_free()
	
	elif nutrient_max == 2 :
		water_indicator_6.queue_free()
		water_indicator_5.queue_free()
		water_indicator_4.queue_free()
		water_indicator_2.queue_free()
		
	elif nutrient_max == 2 :
		water_indicator_6.queue_free()
		water_indicator_5.queue_free()
		water_indicator_4.queue_free()
		water_indicator_2.queue_free()
		water_indicator_1.queue_free()

func set_remaining_water():
	number_of_nutrient = 0
	for i in nutrient :
		number_of_nutrient += 1
		print ("nimberof nutrient  ",number_of_nutrient)
		var water_logo = get_node("VBoxContainer/water_container_" + str(number_of_nutrient) + "/water_indicator_" + str(number_of_nutrient))
		water_logo.set_texture(water_texture)

func _on_water_button_pressed():
	for node in get_tree().get_nodes_in_group("tree") :
		if node.tree_id == self.id :					
			emit_signal("tree_energized")

			node.health = node.health_max
			
func _on_evolution_button_pressed():
	var evolution_panel = evolution_panel_scene.instance()
	$evolution_spot.add_child(evolution_panel)
	evolution_panel.position = Vector2 (- 750, 0 )
	

func _on_close_button_pressed():
	self.queue_free()
