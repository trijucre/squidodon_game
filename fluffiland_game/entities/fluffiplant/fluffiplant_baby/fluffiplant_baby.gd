extends StaticBody2D

signal water_spend

var save_value = "Persist_child"

var evolution_1 = "tree"
var evolution_1_text = "bush_path"
var cost_text_1 = 25

var evolution_2 = "fruit_tree"
var evolution_2_text = "fruit_path"
var cost_text_2 = 25

var evolution_3 = "clover_tree"
var evolution_3_text = "clover_path"
var cost_text_3 = 25


var health = 5
var health_max = 5
var energy = 3
var energy_max = 3

var ressource_generation = 0

onready var sprite = $AnimatedSprite
onready var life_area = $life_space/life_area
onready var area_radius = life_area.shape.radius
export(String) var random_noun
export(String) var random_adjective
var creature_name 

var sleep_hour
var sleeping = false
var id = str(self.get_instance_id())

var gender = "neutral"
var specie = "fluffisprout"
var opposite_gender
var happiness = 0
var max_happiness = 10
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var age = 1
var adult_time = 0

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var used_position = Vector2(-30, -120)
onready var adult_scene = preload("res://entities/fluffiplant/fluffiplant_adult/fluffiplant.tscn")
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
	if sleep_hour == null :
		sleep_hour = 0.7 + (randf() * 0.2 + 0.05)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	ressource_generation += 1
	adult_time += 1

	if ressource_generation >= 60 :
		if get_tree().root.get_node("Game//game_start").water_count > 0 :
			emit_signal("water_spend", 1)
			var used = used_indicator.instance()
			self.add_child(used)
			used.position = used_position
		else :
			health -= 1
		age += 1
		
		if 	get_tree().root.get_node("Game/game_start").rain_falling == true :
			happiness += 2
			var happy_bubble = love_bubble.instance()
			self.add_child(happy_bubble)
			happy_bubble.position = used_position
		ressource_generation = 0
	if adult_time >= 240 :
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
		"adult_time" : adult_time
	}
	return save

	#produced.position.y = self.position.y 
	#pearl_timer.start()	
