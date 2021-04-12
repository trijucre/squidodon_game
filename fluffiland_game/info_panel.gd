extends Node2D


onready var info_name = $info_panel_text/name
onready var info_specie = $info_panel_text/specie
onready var info_mood = $mood
onready var gender = $gender
onready var pregnant = $pregnant
onready var animal_picture = $animal_picture
onready var health_bar = $health_bar
onready var energy_bar = $energy_bar

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

onready var mood_texture_happy = load("res://GUI/info_panel/info_panel_happy.png")
onready var mood_texture_meh = load("res://GUI/info_panel/info_panel_meh.png")
onready var mood_texture_sad = load("res://GUI/info_panel/info_panel_sad.png")
onready var male_logo = load("res://GUI/info_panel/info_panel_base_logomale.png")
onready var female_logo = load ("res://GUI/info_panel/info_panel_base_logofemale.png")
onready var pregnant_logo = load ("res://GUI/info_panel/pregnant_logo.png")

onready var energy_full = load ("res://GUI/info_panel/health_and_energy_bar/energy_bar_full.png")
onready var energy_6 = load ("res://GUI/info_panel/health_and_energy_bar/energy_bar_6.png")
onready var energy_5 = load ("res://GUI/info_panel/health_and_energy_bar/energy_bar_5.png")
onready var energy_4 = load ("res://GUI/info_panel/health_and_energy_bar/energy_bar_4.png")
onready var energy_3 = load ("res://GUI/info_panel/health_and_energy_bar/energy_bar_3.png")
onready var energy_2 = load ("res://GUI/info_panel/health_and_energy_bar/energy_bar_2.png")
onready var energy_1 = load ("res://GUI/info_panel/health_and_energy_bar/energy_bar_1.png")

onready var health_full = load ("res://GUI/info_panel/health_and_energy_bar/health_bar_full.png")
onready var health_6 = load ("res://GUI/info_panel/health_and_energy_bar/health_bar_6.png")
onready var health_5 = load ("res://GUI/info_panel/health_and_energy_bar/health_bar_5.png")
onready var health_4 = load ("res://GUI/info_panel/health_and_energy_bar/health_bar_4.png")
onready var health_3 = load ("res://GUI/info_panel/health_and_energy_bar/health_bar_3.png")
onready var health_2 = load ("res://GUI/info_panel/health_and_energy_bar/health_bar_2.png")
onready var health_1 = load ("res://GUI/info_panel/health_and_energy_bar/health_bar_1.png")

var health_visual 
var energy_visual

onready var painting = load ("res://GUI/info_panel/info_panel_picture/" + specie_text + "_picture.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("info_panel") :
		node.queue_free()
		
	add_to_group("info_panel")
	
	health_visual = ( float (pv)/ float (pv_max) )
	energy_visual = (float (energy) / float (energy_max) )
	
	self.position = Vector2(1635, 325)
	info_name.text = str(name_text)
	info_specie.text = str(specie_text)

	
	if mood > love_happiness :
		info_mood.set_texture(mood_texture_happy)
		
	elif mood < 0.25 :
		info_mood.set_texture(mood_texture_sad)
		
	else :
		info_mood.set_texture(mood_texture_meh)
	
	if gender_text  == "female" :
		gender.set_texture(female_logo)
	
	elif gender_text == "male" :
		gender.set_texture(male_logo)
	
	if pregnancy == true :
		pregnant.set_texture(pregnant_logo)
		
	animal_picture.set_texture(painting)
	
	#set helth and energy texture depending of stats
	if health_visual >= 0.86 :
		health_bar.set_texture(health_full)
		
	elif health_visual >= 0.72 :
		health_bar.set_texture(health_6)
		
	elif health_visual >= 0.58 :
		health_bar.set_texture(health_5)
	
	elif health_visual >= 0.44 :
		health_bar.set_texture(health_4)
		
	elif health_visual >= 0.30 :
		health_bar.set_texture(health_3)
	
	elif health_visual >= 0.16 :
		health_bar.set_texture(health_2)
	
	elif health_visual > 0 :
		health_bar.set_texture(health_1)
	
	else :
		health_bar.set_texture(null)
		
	
	if energy_visual >= 0.86 :
		energy_bar.set_texture(energy_full)
		
	elif energy_visual >= 0.72 :
		energy_bar.set_texture(energy_6)
		
	elif energy_visual >= 0.58 :
		energy_bar.set_texture(energy_5)
	
	elif energy_visual >= 0.44 :
		energy_bar.set_texture(energy_4)
		
	elif energy_visual >= 0.30 :
		energy_bar.set_texture(energy_3)
	
	elif energy_visual >= 0.16 :
		energy_bar.set_texture(energy_2)
	
	elif energy_visual > 0 :
		energy_bar.set_texture(energy_1)
	
	else :
		energy_bar.set_texture(null)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_close_button_pressed():
	self.queue_free()
