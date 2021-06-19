extends Node2D


onready var info_name = $info_panel_text/name
onready var info_pregnant = $info_panel_text/pregnant
onready var info_specie = $info_panel_text/specie
onready var info_mood = $mood/mood_indicator
onready var gender = $gender
onready var pregnant = $pregnant
onready var health_bar = $health_bar
onready var energy_bar = $energy_bar
onready var energy_bar_back = $energy_bar_back
onready var health_bar_back = $health_bar_back
onready var happiness_bar = $happiness_bar
onready var happiness_bar_back = $happiness_bar_back
onready var love_happiness_bar = $love_happiness_bar
onready var info_love_happiness = $mood/love_happiness
onready var age_text = $info_panel_text/age
onready var id
onready var evolution_panel_scene = preload("res://GUI/evolution_panel/evolution_panel.tscn")

onready var produce_1_sprite = $eat_produce/produce_1
onready var produce_2_sprite = $eat_produce/produce_2
onready var eat_1_sprite = $eat_produce/eat_1
onready var eat_2_sprite = $eat_produce/eat_2

onready var produce_1
onready var produce_2
onready var eat_1
onready var eat_2



onready var evolution_1
onready var evolution_2
onready var evolution_3
onready var evolution_1_text
onready var evolution_2_text
onready var evolution_3_text
onready var cost_text_1 
onready var cost_text_2 
onready var cost_text_3

var name_text 
var specie_text 
var pv_text 
var pv 
var pv_max
var energy_text 
var energy
var energy_max
var gender_text 
var happiness
var max_happiness
var love_happiness
var pregnancy
var age

onready var mood_texture_happy = load("res://GUI/info_panel/info_panel_happy.png")
onready var mood_texture_meh = load("res://GUI/info_panel/info_panel_meh.png")
onready var mood_texture_sad = load("res://GUI/info_panel/info_panel_sad.png")
onready var male_logo = load("res://GUI/info_panel/info_panel_base_logomale.png")
onready var female_logo = load ("res://GUI/info_panel/info_panel_base_logofemale.png")
onready var pregnant_logo = load ("res://GUI/info_panel/pregnant_logo.png")





# Called when the node enters the scene tree for the first time.
func _ready():
	print ("info panel" ,gender, " ,", pregnancy)
	for node in get_tree().get_nodes_in_group("info_panel") :
		node.queue_free()
		
	add_to_group("info_panel")
	
	self.position = Vector2(960, 600)
	
	info_name.text = "hi :) My name is " + str(name_text) + ", I'm a  [b]" + str(specie_text ) + "[/b] ,\nmy gender is " +str(gender_text) +" and I'm "+ str(age) + " year old !"
	
	if gender_text == "female" :
		if pregnancy == false :
			info_pregnant.text = "I'm not waiting for a child ."
		else :
			info_pregnant.text = "I'm waiting for a child ^ _ ^"
	
	if eat_1 == null :
		age_text.text =	"I don't need to eat anything :)"
	
	elif eat_2 == null :
		age_text.text = "I like to eat " + str(eat_1) 
	else :
		age_text.text = "I like to eat " + str(eat_1) +" and " + str(eat_2)

	
	health_bar.rect_size.x = 10 * (float (pv))
	energy_bar.rect_size.x = 10 * (float (energy))
	
	health_bar_back.rect_size.x = 10 * (float(pv_max))
	energy_bar_back.rect_size.x = 10 * (float(energy_max))
	
	happiness_bar.rect_size.x = 5 * (float(happiness))
	happiness_bar_back.rect_size.x = 5 * (float(max_happiness))
	love_happiness_bar.rect_size.x = 5 * (float(max_happiness) * float(love_happiness))

	get_tree().paused = true
func _on_close_button_pressed():
	
	get_tree().paused = false
	self.queue_free()


func _on_evolution_button_pressed():
	var evolution_panel = evolution_panel_scene.instance()
	evolution_panel.id = id
	evolution_panel.evolution_1 = evolution_1
	evolution_panel.evolution_2 = evolution_2
	evolution_panel.evolution_3 = evolution_3
	evolution_panel.evolution_1_text = evolution_1_text
	evolution_panel.evolution_2_text = evolution_2_text
	evolution_panel.evolution_3_text = evolution_3_text	
	evolution_panel.cost_text_1 = cost_text_1
	evolution_panel.cost_text_2 = cost_text_2
	evolution_panel.cost_text_3 = cost_text_3
		
	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(evolution_panel)
	evolution_panel.position = self.position
	
	#evolution_panel.position.y = self.position.y 
