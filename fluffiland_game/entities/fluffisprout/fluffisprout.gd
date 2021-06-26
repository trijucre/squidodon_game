extends StaticBody2D

var save_value = "Persist_child"

var evolution_1 = "fluffilus"
var evolution_1_text = "animal_path"
var cost_text_1 = 15

var evolution_2 = "fluffiplant"
var evolution_2_text = "plant_path"
var cost_text_2 = 5

var evolution_3 = "fluffishroom"
var evolution_3_text = "mushroom_path"
var cost_text_3 = 2


var gender
var health = 3
var health_max = 3

var energy = 3
var energy_max = 3

onready var sprite = $sprite
onready var life_area = $fluffi_node_base/life_space/life_area
onready var timer = $fluffi_node_base/Timer
onready var area_radius = life_area.shape.radius
export(String) var random_noun
export(String) var random_adjective
var creature_name 
var happiness = 0
var max_happiness = 10
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var time = 0
var age = 1

var sleep_hour
var sleeping = false
var id = str(self.get_instance_id())

var specie = "fluffisprout"

var orientation_choice

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
	print ("fluffi gender  ", gender)
	add_to_group(specie, true)
	add_to_group ("Persist", true)
	add_to_group ("creature", true)
	add_to_group("Persist_child", true)
	add_to_group("tree", true)
	add_to_group(id, true)
	
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
	timer.connect("timeout", self, "_on_Timer_timeout")
	
	
func set_sleep():

	var animation = "side_sleep"
	sprite.play(animation)

func _on_info_panel_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel/info_panel.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.gender_text =  gender
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.energy = energy
	info_panel.energy_max = energy_max
	info_panel.energy_text = str (energy, "/", energy_max)
	info_panel.name_text = creature_name
	info_panel.happiness = happiness
	info_panel.max_happiness = max_happiness
	info_panel.love_happiness = 0
	info_panel.pregnancy = false
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
	

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value,
		"creature_name" : creature_name,
		"sleep_hour" : sleep_hour,
		"gender" : gender,
		"time" : time,
		"age" : age,
		"orientation_choice" : orientation_choice
	}
	return save



func _on_Timer_timeout():
	time += 1
	if time >= 60 :
		age += 1
		time = 0
		
