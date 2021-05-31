extends StaticBody2D

signal water_spend

var save_value = ""

var evolution_1 = "null"
var evolution_1_text = ""
var cost_text_1 = 0

var evolution_2 = "null"
var evolution_2_text = ""
var cost_text_2 = 0

var evolution_3 = "null"
var evolution_3_text = ""
var cost_text_3 = 0


var health = 5
var health_max = 5
var energy = 3
var energy_max = 3

var ressource_generation = 0

onready var sprite = $AnimatedSprite
onready var area_radius = $Area2D/area.shape.radius
export(String) var random_noun
export(String) var random_adjective
var creature_name 

var sleep_hour
var sleeping = false
var id = str(self.get_instance_id())

var gender = "neutral"
var specie = "big_fruit_tree"
var opposite_gender
var happiness = 0
var max_happiness = 100
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var age = 1
var adult_time = 0

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var used_position = Vector2(-30, -120)
onready var adult_scene = load("res://entities/fluffishroom/fluffishroom_adult/fluffishroom.tscn")

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
	
	add_to_group(specie, true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	add_to_group("tree", true)
	add_to_group(id, true)
	add_to_group("creature", true)
	
	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	
	
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)


func _on_info_panel_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel/info_panel.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.gender_text = ""
	info_panel.pv_text = str (health, "/", health_max)
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.energy = energy
	info_panel.energy_max = energy_max
	info_panel.energy_text = str (energy, "/", energy_max)
	info_panel.name_text = creature_name
	info_panel.mood = relative_happiness
	info_panel.love_happiness = love_happiness
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
	
func _process(_delta):
	if health <= 0 :
		self.queue_free()
	
	if health >= health_max :
		health = health_max


func _on_Timer_timeout():
	
	adult_time += 1
	
	if ressource_generation >= 60 :
		age += 1
		emit_signal("water_spend", 3)
	if adult_time >= 180 :
		var adult = adult_scene.instance()
		adult.creature_name = self.creature_name
		adult.happiness = self.happiness
		adult.id = self.id
		adult.age = self.age
		
		get_tree().root.get_node("Game//game_start/YSort").add_child(adult)
		adult.position = self.position			
		
		ressource_generation = 0
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
		"adult_time" : adult_time
	}
	return save

	#produced.position.y = self.position.y 
	#pearl_timer.start()	
