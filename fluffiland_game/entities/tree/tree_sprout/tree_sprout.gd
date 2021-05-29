extends StaticBody2D

signal water_spend
signal gender

onready var area_radius = $Area2D/area.shape.radius

var save_value = "Persist_child"

var bush_time =0
var health_time =0

var cost = 4
var energy = 0
var energy_max = 0
var health = 10
var health_max = 10
var specie = "tree"
onready var used_position = Vector2(-30, -600)


var evolution_1 = "null"
var evolution_1_text = ""
var cost_text_1 = 0

var evolution_2 = "null"
var evolution_2_text = ""
var cost_text_2 = 5

var evolution_3 = "null"
var evolution_3_text = ""
var cost_text_3 = 0


var gender
var opposite_gender
var happiness = 0
var max_happiness = 100
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var pregnant = false
export(String) var random_noun
export(String) var random_adjective
var creature_name 
var age = 1
var adult_time = 0

onready var sprite = $Sprite

var tree_id

onready var love_bubble = preload("res://popup/love_bubble.tscn")
onready var popup_position = Vector2(0, -200)

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var default = preload("res://entities/tree/tree_adult/sprites/tree_good_health.png")
onready var thirsty = preload ("res://entities/tree/tree_adult/sprites/tree_bad_health.png")


onready var adult_scene = preload("res://entities/tree/tree_adult/tree.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():

	randomize()
		
	add_to_group("tree")
	add_to_group("vegetals")
	add_to_group("creature", true)
	add_to_group("Persist", true)
	add_to_group("persist_child", true)

	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")

	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)

	if gender == null :
		gender = "neutral"
		
	if tree_id == null :
		tree_id = str(self.get_instance_id())
	
	add_to_group(tree_id)
		
	emit_signal("gender",self)
#generate name :

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
	
	

func _on_Timer_timeout():
	

	
	health_time += 1
	
	if health_time >= 60 :
		health -= 1

		
		if 	get_tree().root.get_node("Game/game_start").water_count >= 5 :
			
			emit_signal("water_spend", 5)
			health += 1
			if health > health_max :
				health = health_max
			
			var used = used_indicator.instance()
			self.add_child(used)
			used.position = used_position
		
		else : 
			happiness -= 1

				
		if health > float(health_max/6) :
			var animation = "default"
			sprite.play(animation)
		elif health > 0 :
			var animation = "thirsty"
			sprite.play(animation)
				
		elif health <= 0 :
			self.queue_free()
		age += 1	
		
		adult_time += 1
							
		health_time =0
	
	if adult_time >= 3000 :
		var adult = adult_scene.instance()
		adult.creature_name = self.creature_name
		adult.happiness = self.happiness
		adult.tree_id = self.tree_id
		adult.age = self.age
		
		get_tree().root.get_node("Game//game_start/YSort").add_child(adult)
		adult.position = self.position
		self.queue_free()


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
	info_panel.mood = relative_happiness
	info_panel.love_happiness = love_happiness
	info_panel.pregnancy = pregnant
	info_panel.id = tree_id
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
	
func _on_plant_nourished(value):
	var popup = love_bubble.instance()
	self.add_child(popup)
	popup.position = popup_position
	happiness += value
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"health" : health,
		"health_time" : health_time,
		"happiness" : happiness,
		"creature_name" : creature_name,
		"tree_id" : tree_id,
		"age" : age,
		"adult_time" : adult_time
	}

	return save
