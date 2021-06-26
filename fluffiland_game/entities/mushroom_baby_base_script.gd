extends StaticBody2D

var save_value = "Persist_child"

var evolution_1 = null
var evolution_1_text = ""
var cost_text_1 = 0

var evolution_2 = null
var evolution_2_text = ""
var cost_text_2 = 0

var evolution_3 = null
var evolution_3_text = ""
var cost_text_3 = 0


var health = 0
var health_max = 0
var energy = 0
var energy_max = 0

var ressource_generation = 0

var adulthood 


onready var life_area = $fluffi_node_base/life_space/life_area
onready var area_radius = life_area.shape.radius
onready var timer = $fluffi_node_base/Timer

export(String) var random_noun
export(String) var random_adjective
var creature_name 

var sleep_hour
var sleeping = false
var id = str(self.get_instance_id())

var gender = "neutral"
var specie 
var opposite_gender
var happiness = 0
var max_happiness = 0
var relative_happiness
var love_happiness = 0.8
var age = 1
var adult_time = 0

onready var sprite = $Sprite
var orientation_choice


onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var used_position = Vector2(-30, -120)
onready var adult_scene
onready var love_bubble = preload("res://popup/love_bubble.tscn")

func load_file(file_path):
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	return text
	
func get_random_word_from_file(file_path):
	var text = load_file(file_path).strip_edges()
	var words = text.split("\n")
	for i in range(words.size()):
		# here you can add whatever you want to remove
		# any unwanted characters
		words[i] = words[i].replace(",", "")
		words[i] = words[i].replace(".", "")


	return words[randi() % words.size()]
	
	

func _ready():

	if orientation_choice == null :
		orientation_choice = randi()% 100 + 1
	if orientation_choice > 50 :
		sprite.scale.x = -1

	add_to_group(specie, true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	add_to_group("tree", true)
	add_to_group(id, true)
	add_to_group("creature", true)
	
	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	timer.connect("timeout", self, "_on_Timer_timeout")
	
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
	if sleep_hour == null :
		sleep_hour = 0.7 + (randf() * 0.2 + 0.05)



func _on_info_panel_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel/info_panel.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.gender_text = gender
	info_panel.pv_text = str (health, "/", health_max)
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.energy = energy
	info_panel.energy_max = energy_max
	info_panel.energy_text = str (energy, "/", energy_max)
	info_panel.name_text = creature_name
	info_panel.happiness = happiness
	info_panel.max_happiness = max_happiness
	info_panel.love_happiness = love_happiness
	info_panel.id = id
	info_panel.evolution_1 = evolution_1
	info_panel.evolution_2 = evolution_2
	info_panel.evolution_3 = evolution_3
	info_panel.evolution_1_text = evolution_1_text	
	info_panel.evolution_2_text = evolution_2_text
	info_panel.evolution_3_text = evolution_3_text
	info_panel.cost_text_1 = cost_text_1
	info_panel.cost_text_2 = cost_text_2
	info_panel.cost_text_3 = cost_text_3
	info_panel.age = age
			
	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(info_panel)
	



func _on_Timer_timeout():

	adult_time += 1

	if adult_time >= adulthood :
		var adult = adult_scene.instance()
		adult.creature_name = self.creature_name
		adult.happiness = self.happiness
		adult.tree_id = self.id
		adult.age = self.age
		
		get_tree().root.get_node("Game//game_start/YSort").add_child(adult)
		adult.position = self.position			
		self.queue_free()

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value,
		"creature_name" : creature_name,
		"sleep_hour" : sleep_hour,
		"ressource_generation" : ressource_generation,
		"age" : age,
		"adult_time" : adult_time,
		"orientation_choice" : orientation_choice
	}
	return save

	#produced.position.y = self.position.y 
	#pearl_timer.start()	
