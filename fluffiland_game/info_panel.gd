extends Node2D


onready var info_name = $info_panel_text/name
onready var info_specie = $info_panel_text/specie
onready var info_mood = $mood/mood_indicator
onready var gender = $gender
onready var pregnant = $pregnant
onready var animal_picture = $animal_picture
onready var health_bar = $health_bar
onready var energy_bar = $energy_bar
onready var energy_bar_back = $energy_bar_back
onready var health_bar_back = $health_bar_back
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
var mood
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
	
	for node in get_tree().get_nodes_in_group("info_panel") :
		node.queue_free()
		
	add_to_group("info_panel")
	
	self.position = Vector2(1635, 325)
	info_name.text = str(name_text)
	info_specie.text = str(specie_text)

	info_mood.position.y = (200 -float(200 * mood))
	info_love_happiness.position.y = (200 -float(200 * love_happiness))
	
	if gender_text  == "female" :
		gender.set_texture(female_logo)
	
	elif gender_text == "male" :
		gender.set_texture(male_logo)
	
	elif gender_text == "neutral" :
		gender.set_texture(null)
	
	if pregnancy == true :
		pregnant.set_texture(pregnant_logo)
		
	if produce_1 != null :
		var produce_1_logo = load("res://GUI/info_panel/eat_and_produce_graphic/eat_produce_"+ produce_1 + ".png")
		produce_1_sprite.set_texture(produce_1_logo)
	if produce_2 != null :
		var produce_2_logo = load("res://GUI/info_panel/eat_and_produce_graphic/eat_produce_" + produce_2 + ".png")
		produce_2_sprite.set_texture(produce_2_logo)
	if eat_1 != null :
		var eat_1_logo = load("res://GUI/info_panel/eat_and_produce_graphic/eat_produce_"+ eat_1 + ".png")
		eat_1_sprite.set_texture(eat_1_logo)
	if eat_2 != null :
		var eat_2_logo = load("res://GUI/info_panel/eat_and_produce_graphic/eat_produce_"+ eat_2 + ".png")
		eat_2_sprite.set_texture(eat_2_logo)
	#set helth and energy texture depending of stats
	
	health_bar.rect_size.x = 10 * (float (pv))
	energy_bar.rect_size.x = 10 * (float (energy))
	
	health_bar_back.rect_size.x = 10 * (float(pv_max))
	energy_bar_back.rect_size.x = 10 * (float(energy_max))
	
	if age >= 200 :
		age_text.text = str("Age : "+ str(age/ 100) + " years and " + str((age - (age/100) * 100)) + " days")
	elif age >= 100 :
		age_text.text = str("Age : "+ str(age/ 100) + " year and " + str((age - (age/100) * 100)) + " days")
	elif age >1 :
		age_text.text = str("Age : "+ str(age) + " days")
	else :
		age_text.text = str("Age : "+ str(age) + " day")
		
func _on_close_button_pressed():
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
		
	$evolution_spot.add_child(evolution_panel)
	evolution_panel.position = Vector2 (- 750, - 200 )
	
	#evolution_panel.position.y = self.position.y 
