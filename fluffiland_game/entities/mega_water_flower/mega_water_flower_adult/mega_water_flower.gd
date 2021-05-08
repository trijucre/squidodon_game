extends StaticBody2D

signal water_earned


var save_value = "Persist_child"

var evolution_1 = "null"
var evolution_1_text = ""
var cost_text_1 = 0

var evolution_2 = "null"
var evolution_2_text = ""
var cost_text_2 = 0

var evolution_3 = "null"
var evolution_3_text = ""
var cost_text_3 = 0


onready var area_radius = $Area2D/area.shape.radius

onready var pearl_timer = $pearl_generation
onready var sprite = $flower_sprite

onready var produced_indicator = preload("res://popup/produced_spent_indicator/water_produced_indicator.tscn")
onready var used_indicator = preload("res://popup/produced_spent_indicator/strength_used_indicator.tscn")
onready var produced_position = Vector2(30, -120)
onready var used_position = Vector2(-30, -120)

var ressource_generation = 0

var cost = 1
var health = 180
var health_max = 180
var energy = 100
var energy_max = 100

var gender
var opposite_gender
var happiness = 500
var max_happiness = 1000
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var pregnant = false
export(String) var random_noun
export(String) var random_adjective
var creature_name 
var specie = "big_water_flower"# Declare member variables here. Examples:


var tree_id = str(self.get_instance_id())

func _ready():
	randomize()
	
	self.connect("water_earned", get_tree().root.get_node("Game/game_start"), "_on_water_earned")

	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	
	pearl_timer.start()
	
	var animation = "closed"
	sprite.play(animation)
	add_to_group ("flower")
	add_to_group ("vegetals")
	add_to_group ("water_flower")
	add_to_group("tree")
	
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
	
	if gender == null :
		gender = "neutral"

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


func _process(delta):
	
	if health <= 0 :
		self.queue_free()

	

func _on_pearl_generation_timeout():

	ressource_generation += 1
	if ressource_generation >= 60 :
		emit_signal("water_earned", 20)
		var produced = produced_indicator.instance()
		self.add_child(produced)
		produced.position = produced_position
		ressource_generation = 0
	



func _on_water_button_pressed():
	

	#else :
	var info_panel_scene = preload ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/info_panel_vegetals_strength.tscn")
	var info_panel = info_panel_scene.instance()
		
	info_panel.specie_text = specie
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.id = tree_id
		
	get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(info_panel)

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"health" : health,
		"ressource_generation" : ressource_generation,
		"name" : creature_name

	}
	return save

